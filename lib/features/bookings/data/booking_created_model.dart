class BookingCreatedModel {
  final String status;
  final String message;

  const BookingCreatedModel({required this.status, required this.message});

  factory BookingCreatedModel.fromJson(
    Map<String, dynamic> json, {
    required String message,
  }) {
    final booking = json['booking'] as Map<String, dynamic>? ?? const {};
    return BookingCreatedModel(
      status: booking['status'] as String? ?? '',
      message: message,
    );
  }
}
