/// Mirrors backend/src/models/Food.js exactly.
class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // bare filename e.g. "burger-1" -> assets/images/foods/burger-1.png
  final double rating;
  final int numberOfReviews;
  final double currentPrice;
  final double? pastPrice;
  final String category; // stored as category NAME (string), not an id
  final List<String> tags;
  final bool customOrder;
  final bool isAvailable;
  final bool isPopular;
  final bool isSpecial;
  final bool isSuperDeals;
  final DateTime? createdAt;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.numberOfReviews,
    required this.currentPrice,
    this.pastPrice,
    required this.category,
    required this.tags,
    required this.customOrder,
    required this.isAvailable,
    required this.isPopular,
    required this.isSpecial,
    required this.isSuperDeals,
    this.createdAt,
  });

  bool get hasDiscount => pastPrice != null && pastPrice! > currentPrice;

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      numberOfReviews: (json['numberOfReviews'] as num?)?.toInt() ?? 0,
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0,
      pastPrice: (json['pastPrice'] as num?)?.toDouble(),
      category: json['category'] as String? ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      customOrder: json['customOrder'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isPopular: json['isPopular'] as bool? ?? false,
      isSpecial: json['isSpecial'] as bool? ?? false,
      isSuperDeals: json['isSuperDeals'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  /// Payload shape expected by POST /api/foods/add and PUT /api/foods/update/:id
  Map<String, dynamic> toPayload() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'currentPrice': currentPrice,
      if (pastPrice != null) 'pastPrice': pastPrice,
      'isPopular': isPopular,
      'isSpecial': isSpecial,
      'isSuperDeals': isSuperDeals,
      'isAvailable': isAvailable,
    };
  }
}
