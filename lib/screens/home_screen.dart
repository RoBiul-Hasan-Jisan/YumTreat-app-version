import 'package:flutter/material.dart';

import '../models/food.dart';
import '../services/food_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/food_card.dart';
import 'menu_screen.dart';

/// Mirrors app/page.jsx (hero + popular dishes + CTA) — simplified for a
/// mobile home tab, still pulling from the same live /api/foods endpoint.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _foodService = FoodService();
  late Future<List<Food>> _future;

  @override
  void initState() {
    super.initState();
    _future = _foodService.getFoods();
  }

  void _goToMenu(BuildContext context, {String? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MenuScreen(initialCategory: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40, errorBuilder: (_, __, ___) => const SizedBox()),
            const SizedBox(width: 8),
            const Text('YumTreat'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _future = _foodService.getFoods()),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            _Hero(onOrderNow: () => _goToMenu(context)),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Popular right now',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink950),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(onPressed: () => _goToMenu(context), child: const Text('See all')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Food>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(label: 'Loading dishes…');
                }
                if (snapshot.hasError) {
                  return ErrorState(
                    message: "Couldn't load the menu — check that the backend API is running.",
                    onRetry: () => setState(() => _future = _foodService.getFoods()),
                  );
                }
                final foods = (snapshot.data ?? []).where((f) => f.isPopular).toList();
                final show = foods.isNotEmpty ? foods : (snapshot.data ?? []);
                if (show.isEmpty) {
                  return const EmptyState(title: 'No dishes yet', subtitle: 'Check back soon.');
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: show.length > 6 ? 6 : show.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, i) => FoodCard(food: show[i]),
                );
              },
            ),
            const SizedBox(height: 28),
            _CtaBanner(onOrderNow: () => _goToMenu(context)),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onOrderNow;
  const _Hero({required this.onOrderNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.ink950,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delicious food,\ndelivered fast.',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.15),
          ),
          const SizedBox(height: 10),
          Text(
            'Fresh dishes from our kitchen to your door — order in a couple of taps.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onOrderNow, child: const Text('Order now')),
        ],
      ),
    );
  }
}

class _CtaBanner extends StatelessWidget {
  final VoidCallback onOrderNow;
  const _CtaBanner({required this.onOrderNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.ember500, AppColors.ember600]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hungry already?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Browse the full menu and get something delicious on the way.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
            onPressed: onOrderNow,
            child: const Text('Browse menu'),
          ),
        ],
      ),
    );
  }
}
