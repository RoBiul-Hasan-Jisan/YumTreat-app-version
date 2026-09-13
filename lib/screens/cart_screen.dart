import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/food_image.dart';
import 'checkout_screen.dart';
import 'menu_screen.dart';

/// Mirrors app/cart/page.jsx.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (!cart.hydrated) {
      return const Scaffold(body: Loader());
    }

    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your cart')),
        body: EmptyState(
          title: 'Your cart is empty',
          subtitle: 'Add something tasty from the menu.',
          action: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MenuScreen())),
            child: const Text('Browse the menu'),
          ),
        ),
      );
    }

    const deliveryFee = 2.99;
    final total = cart.subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cart.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final item = cart.items[i];
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)]),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppColors.ember50, borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(6),
                  child: FoodImage(imageUrl: item.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('\$${item.currentPrice.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.ember600, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => context.read<CartProvider>().setQuantity(item.id, item.quantity - 1),
                    ),
                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => context.read<CartProvider>().setQuantity(item.id, item.quantity + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.ember700),
                  onPressed: () => context.read<CartProvider>().removeItem(item.id),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal', style: TextStyle(color: Colors.black54)),
                  Text('\$${cart.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery fee', style: TextStyle(color: Colors.black54)),
                  Text('\$${deliveryFee.toStringAsFixed(2)}'),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.ember600)),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
