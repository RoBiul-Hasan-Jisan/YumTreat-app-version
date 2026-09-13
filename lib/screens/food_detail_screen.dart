import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../models/review.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/food_service.dart';
import '../services/review_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/food_card.dart';
import '../widgets/food_image.dart';
import 'signin_screen.dart';

/// Mirrors app/menu/[id]/page.jsx + components/ReviewsPanel.jsx.
class FoodDetailScreen extends StatefulWidget {
  final String foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final _foodService = FoodService();
  final _reviewService = ReviewService();

  Food? _food;
  List<Food> _related = [];
  List<Review> _reviews = [];
  String _status = 'loading';
  int _qty = 1;
  bool _added = false;

  // review form
  int _rating = 5;
  final _feedbackController = TextEditingController();
  bool _submittingReview = false;
  String? _reviewError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = 'loading');
    try {
      final food = await _foodService.getFoodById(widget.foodId);
      setState(() {
        _food = food;
        _status = 'ready';
      });
      _foodService.getFoods().then((all) {
        if (!mounted) return;
        setState(() => _related = all.where((f) => f.category == food.category && f.id != food.id).take(4).toList());
      }).catchError((_) {});
      _reviewService.getReviewsByProduct(widget.foodId).then((r) {
        if (!mounted) return;
        setState(() => _reviews = r);
      }).catchError((_) {
        if (mounted) setState(() => _reviews = []);
      });
    } catch (_) {
      setState(() => _status = 'error');
    }
  }

  Future<void> _submitReview() async {
    if (_feedbackController.text.trim().isEmpty) return;
    setState(() {
      _submittingReview = true;
      _reviewError = null;
    });
    try {
      final review = await _reviewService.addReview(
        productId: widget.foodId,
        rating: _rating,
        feedback: _feedbackController.text.trim(),
      );
      setState(() {
        _reviews = [review, ..._reviews];
        _feedbackController.clear();
        _rating = 5;
      });
    } catch (e) {
      setState(() => _reviewError = e.toString());
    } finally {
      if (mounted) setState(() => _submittingReview = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == 'loading') {
      return const Scaffold(body: Loader(label: 'Loading dish…'));
    }
    if (_status == 'error' || _food == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorState(message: "We couldn't find that dish.", onRetry: _load),
      );
    }

    final food = _food!;
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;

    return Scaffold(
      appBar: AppBar(title: Text(food.name, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.ember50, Color(0xFFFFEAD4)]),
                borderRadius: BorderRadius.circular(32),
              ),
              child: FoodImage(imageUrl: food.imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.category.toUpperCase(), style: const TextStyle(color: AppColors.ember600, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(food.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.ink950)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Stars(rating: food.rating),
                    const SizedBox(width: 8),
                    Text('${food.rating.toStringAsFixed(1)} (${food.numberOfReviews} reviews)', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(food.description, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                if (food.tags.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: food.tags
                        .map((t) => Chip(label: Text(t), backgroundColor: const Color(0x0D0B0A08), side: BorderSide.none))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${food.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.ember600)),
                    if (food.hasDiscount) ...[
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text('\$${food.pastPrice!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.black38, decoration: TextDecoration.lineThrough)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0x1A0B0A08))),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => _qty = _qty > 1 ? _qty - 1 : 1)),
                          Text('$_qty', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _qty++)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _added ? const Color(0xFF16A34A) : AppColors.ember500,
                        ),
                        onPressed: () {
                          context.read<CartProvider>().addItem(food, qty: _qty);
                          setState(() => _added = true);
                          Future.delayed(const Duration(milliseconds: 1800), () {
                            if (mounted) setState(() => _added = false);
                          });
                        },
                        icon: Icon(_added ? Icons.check : Icons.shopping_bag_outlined),
                        label: Text(_added ? 'Added!' : 'Add to cart'),
                      ),
                    ),
                  ],
                ),
                if (!food.isAvailable) ...[
                  const SizedBox(height: 12),
                  const Text('Currently unavailable — check back soon.', style: TextStyle(color: AppColors.ember700, fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('Customer reviews', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink950)),
          ),
          if (_reviews.isEmpty)
            const EmptyState(title: 'No reviews yet', subtitle: 'Be the first to share how this dish tasted.')
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: _reviews
                    .map((r) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stars(rating: r.rating.toDouble()),
                                  if (r.createdAt != null)
                                    Text('${r.createdAt!.month}/${r.createdAt!.day}/${r.createdAt!.year}', style: const TextStyle(fontSize: 11, color: Colors.black38)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(r.feedback, style: const TextStyle(fontSize: 13.5, color: Colors.black87)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 14)]),
              child: isAuthenticated
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Leave a review', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (i) {
                            final n = i + 1;
                            final selected = n <= _rating;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: () => setState(() => _rating = n),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.saffron : const Color(0x0D0B0A08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('$n', style: TextStyle(fontWeight: FontWeight.w800, color: selected ? AppColors.ink950 : Colors.black45)),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _feedbackController,
                          maxLines: 3,
                          decoration: const InputDecoration(hintText: 'How was it?'),
                        ),
                        if (_reviewError != null) ...[
                          const SizedBox(height: 8),
                          Text(_reviewError!, style: const TextStyle(color: AppColors.ember700, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submittingReview ? null : _submitReview,
                            child: Text(_submittingReview ? 'Submitting…' : 'Submit review'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: const Text('Sign in to leave a review for this dish.', style: TextStyle(color: Colors.black54))),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
            ),
          ),
          if (_related.isNotEmpty) ...[
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('You might also like', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink950)),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _related.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, i) => FoodCard(food: _related[i]),
            ),
          ],
        ],
      ),
    );
  }
}
