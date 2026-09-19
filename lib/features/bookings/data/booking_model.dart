class BookingModel {
  final BookingInfo booking;
  final BookingBusiness business;
  final ServicePreview servicePreview;
  final BookingSchedule schedule;
  final BookingActions actions;

  const BookingModel({
    required this.booking,
    required this.business,
    required this.servicePreview,
    required this.schedule,
    required this.actions,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      booking: BookingInfo.fromJson(
        json['booking'] as Map<String, dynamic>? ?? const {},
      ),
      business: BookingBusiness.fromJson(
        json['business'] as Map<String, dynamic>? ?? const {},
      ),
      servicePreview: ServicePreview.fromJson(
        json['service_preview'] as Map<String, dynamic>? ?? const {},
      ),
      schedule: BookingSchedule.fromJson(
        json['schedule'] as Map<String, dynamic>? ?? const {},
      ),
      actions: BookingActions.fromJson(
        json['actions'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class BookingInfo {
  final String id;

  /// Free-form status string from the API; mapped to an icon/colour/label in
  /// the widget layer rather than parsed into an enum here.
  final String status;
  final String tab;

  const BookingInfo({
    required this.id,
    required this.status,
    required this.tab,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      tab: json['tab'] as String? ?? '',
    );
  }
}

class BookingBusiness {
  final String id;
  final String name;

  const BookingBusiness({required this.id, required this.name});

  factory BookingBusiness.fromJson(Map<String, dynamic> json) {
    return BookingBusiness(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class ServicePreview {
  final String primaryServiceName;
  final int serviceCount;

  const ServicePreview({
    required this.primaryServiceName,
    required this.serviceCount,
  });

  factory ServicePreview.fromJson(Map<String, dynamic> json) {
    return ServicePreview(
      primaryServiceName: json['primary_service_name'] as String? ?? '',
      serviceCount: (json['service_count'] as num? ?? 0).toInt(),
    );
  }

  /// `Haircut` or `Haircut +2 more` when the booking has extra services.
  String get label {
    if (primaryServiceName.isEmpty) return '';
    if (serviceCount <= 1) return primaryServiceName;
    return '$primaryServiceName +${serviceCount - 1} more';
  }
}

class BookingSchedule {
  /// Null when the API omits or sends an unparseable timestamp.
  final DateTime? startsAt;

  const BookingSchedule({this.startsAt});

  factory BookingSchedule.fromJson(Map<String, dynamic> json) {
    return BookingSchedule(
      startsAt: DateTime.tryParse(json['starts_at'] as String? ?? ''),
    );
  }
}

class BookingActions {
  final bool canReschedule;
  final bool canCancel;

  const BookingActions({required this.canReschedule, required this.canCancel});

  factory BookingActions.fromJson(Map<String, dynamic> json) {
    return BookingActions(
      canReschedule: json['can_reschedule'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  bool get hasAny => canReschedule || canCancel;
}
