class ReviewerModel {
  /// Already shortened by the server ("Sarah J." or "Anonymous") — print as-is.
  final String name;

  /// Null when the reviewer has no picture — show an initial instead.
  final String? photoUrl;

  const ReviewerModel({required this.name, required this.photoUrl});

  factory ReviewerModel.fromJson(Map<String, dynamic> json) => ReviewerModel(
    name: json['name'] as String? ?? '',
    photoUrl: json['photo_url'] as String?,
  );
}

/// One row of `GET /customer/businesses/{business_id}/reviews`.
class ReviewModel {
  final String id;
  final ReviewerModel reviewer;

  /// 1–5.
  final int rating;

  /// Null for a star-only review — draw the name and stars, no comment.
  final String? comment;

  final DateTime? createdAt;

  /// Differs from [createdAt] when the customer edited the review later.
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'] as String? ?? '',
    reviewer: ReviewerModel.fromJson(
      json['reviewer'] as Map<String, dynamic>? ?? const {},
    ),
    rating: (json['rating'] as num? ?? 0).toInt(),
    comment: json['comment'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
  );
}
