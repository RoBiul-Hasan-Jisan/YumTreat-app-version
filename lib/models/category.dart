/// Mirrors backend/src/models/Category.js
class FoodCategory {
  final String id;
  final String name;
  final String img; // bare filename e.g. "cat-1" -> assets/images/categories/cat-1.png

  FoodCategory({required this.id, required this.name, required this.img});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
    );
  }
}
