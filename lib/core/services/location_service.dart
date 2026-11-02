import 'package:geolocator/geolocator.dart';
import 'package:noq/core/services/secure_storage_service.dart';

class SavedLocation {
  final double latitude;
  final double longitude;

  const SavedLocation({required this.latitude, required this.longitude});
}

class LocationService {
  LocationService._internal();

  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;

  SavedLocation? _saved;

  /// The last position Home stored, or null if there is none. Never touches
  /// GPS or asks for permission, so it is safe to await before any API call.
  /// Never throws.
  Future<SavedLocation?> getSavedLocation() async {
    if (_saved != null) return _saved;
    try {
      final stored = await SecureStorageService().getLocation();
      if (stored == null) return null;
      return _saved = SavedLocation(
        latitude: stored.latitude,
        longitude: stored.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  /// Takes a new fix and saves it. Only Home calls this: it can ask for
  /// permission and can wait on GPS.
  ///
  /// Location off or permission denied deletes the saved position, so it is not
  /// sent after the customer turned location off. With no fix available the
  /// saved position is kept and returned. Never throws.
  Future<SavedLocation?> refreshLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        await clear();
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await clear();
        return null;
      }

      final position = await _takeFix();
      if (position == null) return getSavedLocation();

      _saved = SavedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      await SecureStorageService().saveLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      return _saved;
    } catch (_) {
      return getSavedLocation();
    }
  }

  /// Forgets the saved position. Never throws.
  Future<void> clear() async {
    _saved = null;
    try {
      await SecureStorageService().clearLocation();
    } catch (_) {
      // Logout must not fail over this.
    }
  }

  Future<Position?> _takeFix() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );
    } catch (_) {
      return await Geolocator.getLastKnownPosition();
    }
  }
}
