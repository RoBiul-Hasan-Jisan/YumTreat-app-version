import 'package:flutter/material.dart';

/// Food.imageUrl / Category.img are bare filenames (e.g. "burger-1")
/// bundled as Flutter assets — mirrors foodImage()/categoryImage() in
/// frontend/lib/api.js, which resolve the same bare names against
/// /public/images/{foods,categories}/<name>.png.
String foodImagePath(String imageUrl) {
  if (imageUrl.startsWith('http')) return imageUrl;
  return 'assets/images/foods/$imageUrl.png';
}

String categoryImagePath(String img) {
  if (img.startsWith('http')) return img;
  return 'assets/images/categories/$img.png';
}

class FoodImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  const FoodImage({super.key, required this.imageUrl, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    final path = foodImagePath(imageUrl);
    if (path.startsWith('http')) {
      return Image.network(path, fit: fit, errorBuilder: (_, __, ___) => const _FallbackIcon());
    }
    return Image.asset(path, fit: fit, errorBuilder: (_, __, ___) => const _FallbackIcon());
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Icons.restaurant, color: Colors.black26, size: 32));
  }
}
