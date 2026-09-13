import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';
import 'food_image.dart';

class CategoryStrip extends StatelessWidget {
  final List<FoodCategory> categories;
  final String? active;
  final ValueChanged<String?> onSelect;

  const CategoryStrip({super.key, required this.categories, required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(context, label: 'All', selected: active == null, onTap: () => onSelect(null)),
          const SizedBox(width: 8),
          ...categories.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _chip(
                  context,
                  label: c.name,
                  imagePath: categoryImagePath(c.img),
                  selected: active == c.name,
                  onTap: () => onSelect(c.name),
                ),
              )),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, {required String label, String? imagePath, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink950 : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.ink950 : const Color(0x1A0B0A08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) ...[
              SizedBox(width: 18, height: 18, child: Image.asset(imagePath, errorBuilder: (_, __, ___) => const SizedBox())),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.ink900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
