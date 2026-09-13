/// Mirrors backend/src/models/Review.js
class Review {
  final String id;
  final String orderId;
  final String userId;
  final String productId;
  final int rating;
  final String feedback;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.feedback,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] as String,
      orderId: json['orderID'] as String? ?? '',
      userId: json['userID'] as String? ?? '',
      productId: json['productID'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      feedback: json['feedback'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
