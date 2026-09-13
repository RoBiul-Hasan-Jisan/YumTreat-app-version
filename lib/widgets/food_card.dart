import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/cart_provider.dart';
import '../screens/food_detail_screen.dart';
import '../theme/app_theme.dart';
import 'food_image.dart';

/// Mirrors components/FoodCard.jsx — image, badge, rating, name,
/// price(+past price struck through), quick add-to-cart button.
class FoodCard extends StatefulWidget {
  final Food food;
  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool justAdded = false;

  void _handleAdd() {
    context.read<CartProvider>().addItem(widget.food);
    setState(() => justAdded = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => justAdded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final badge = food.hasDiscount ? 'Sale' : (food.isSpecial ? "Chef's pick" : (food.isPopular ? 'Popular' : null));

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: food.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, 8))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded (not AspectRatio) so the image area always shrinks
            // or grows to whatever room is left after the text below it —
            // this is what actually prevents bottom overflow, regardless
            // of the exact grid cell aspect ratio a screen uses.
            //
            // Wrapped in its own ClipRect (on top of the outer Container's
            // clipBehavior) so the image can never visually bleed past its
            // cell under any renderer, even if the outer clip is somehow
            // not applied to this subtree.
            Expanded(
              child: ClipRect(
                child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.ember50, Color(0xFFFFEAD4)],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: FoodImage(imageUrl: food.imageUrl),
                  ),
                  if (badge != null)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppColors.ink950, borderRadius: BorderRadius.circular(999)),
                        child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ),
                ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.saffron),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${food.rating.toStringAsFixed(1)} · ${food.numberOfReviews} reviews',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink950),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    food.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${food.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ember600),
                          ),
                          if (food.hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${food.pastPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      InkWell(
                        onTap: _handleAdd,
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: justAdded ? const Color(0xFF16A34A) : AppColors.ink950,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(justAdded ? Icons.check : Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
