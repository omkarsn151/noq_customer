class SlotOperations {
  final int blockMinutes;
  final int bufferMinutes;
  final int bookingLimitPerSlot;
  final int bookingWindowDays;
  final int cancellationCutoffHours;
  final String lateCancellationFeePercent;
  final bool autoApproveEnabled;

  const SlotOperations({
    required this.blockMinutes,
    required this.bufferMinutes,
    required this.bookingLimitPerSlot,
    required this.bookingWindowDays,
    required this.cancellationCutoffHours,
    required this.lateCancellationFeePercent,
    required this.autoApproveEnabled,
  });

  factory SlotOperations.fromJson(Map<String, dynamic> json) => SlotOperations(
    blockMinutes: (json['block_minutes'] as num? ?? 0).toInt(),
    bufferMinutes: (json['buffer_minutes'] as num? ?? 0).toInt(),
    bookingLimitPerSlot: (json['booking_limit_per_slot'] as num? ?? 0).toInt(),
    bookingWindowDays: (json['booking_window_days'] as num? ?? 0).toInt(),
    cancellationCutoffHours: (json['cancellation_cutoff_hours'] as num? ?? 0)
        .toInt(),
    lateCancellationFeePercent:
        json['late_cancellation_fee_percent'] as String? ?? '0',
    autoApproveEnabled: json['auto_approve_enabled'] ?? false,
  );
}

class SlotBusiness {
  final String id;
  final String name;
  final SlotOperations operations;

  const SlotBusiness({
    required this.id,
    required this.name,
    required this.operations,
  });

  factory SlotBusiness.fromJson(Map<String, dynamic> json) => SlotBusiness(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    operations: SlotOperations.fromJson(
      json['operations'] as Map<String, dynamic>? ?? {},
    ),
  );
}

class SlotDate {
  final String date;
  final String weekday;
  final bool isToday;
  final bool isClosed;

  const SlotDate({
    required this.date,
    required this.weekday,
    required this.isToday,
    required this.isClosed,
  });

  /// Day-of-month portion of [date], used for the date chip label.
  String get dayNumber => date.split('-').last;

  factory SlotDate.fromJson(Map<String, dynamic> json) => SlotDate(
    date: json['date'] as String? ?? '',
    weekday: json['weekday'] as String? ?? '',
    isToday: json['is_today'] ?? false,
    isClosed: json['is_closed'] ?? false,
  );
}

class SlotWindow {
  final String timezone;
  final String selectedDate;
  final List<SlotDate> dates;

  const SlotWindow({
    required this.timezone,
    required this.selectedDate,
    required this.dates,
  });

  factory SlotWindow.fromJson(Map<String, dynamic> json) => SlotWindow(
    timezone: json['timezone'] as String? ?? '',
    selectedDate: json['selected_date'] as String? ?? '',
    dates: (json['dates'] as List<dynamic>? ?? [])
        .map((e) => SlotDate.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class SlotTime {
  final DateTime start;
  final DateTime end;
  final String status;

  const SlotTime({
    required this.start,
    required this.end,
    required this.status,
  });

  bool get isPast => status == 'past';

  bool get isAvailable => status == 'available';

  factory SlotTime.fromJson(Map<String, dynamic> json) => SlotTime(
    start: DateTime.tryParse(json['start'] as String? ?? '') ?? DateTime.now(),
    end: DateTime.tryParse(json['end'] as String? ?? '') ?? DateTime.now(),
    status: json['status'] as String? ?? '',
  );
}

class StaffMember {
  final String id;
  final String name;
  final String photoUrl;

  const StaffMember({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) => StaffMember(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    photoUrl: json['photo_url'] as String? ?? '',
  );
}

class SlotSummary {
  final String currencyCode;
  final String totalPayable;
  final int servicesCount;
  final int totalDurationMinutes;

  const SlotSummary({
    required this.currencyCode,
    required this.totalPayable,
    required this.servicesCount,
    required this.totalDurationMinutes,
  });

  factory SlotSummary.fromJson(Map<String, dynamic> json) => SlotSummary(
    currencyCode: json['currency_code'] as String? ?? '',
    totalPayable: json['total_payable'] as String? ?? '0',
    servicesCount: (json['services_count'] as num? ?? 0).toInt(),
    totalDurationMinutes: (json['total_duration_minutes'] as num? ?? 0).toInt(),
  );
}

class SlotModel {
  final SlotBusiness business;
  final SlotWindow window;
  final List<SlotTime> times;
  final List<StaffMember> staffMembers;
  final SlotSummary summary;

  const SlotModel({
    required this.business,
    required this.window,
    required this.times,
    required this.staffMembers,
    required this.summary,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    final staff = json['staff'] as Map<String, dynamic>? ?? {};
    return SlotModel(
      business: SlotBusiness.fromJson(
        json['business'] as Map<String, dynamic>? ?? {},
      ),
      window: SlotWindow.fromJson(
        json['window'] as Map<String, dynamic>? ?? {},
      ),
      times: (json['times'] as List<dynamic>? ?? [])
          .map((e) => SlotTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      staffMembers: (staff['members'] as List<dynamic>? ?? [])
          .map((e) => StaffMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: SlotSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
