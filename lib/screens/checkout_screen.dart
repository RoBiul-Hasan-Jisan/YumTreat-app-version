import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'menu_screen.dart';
import 'root_shell.dart';
import 'signin_screen.dart';

const _paymentMethods = [
  {'id': 'cash', 'label': 'Cash on delivery'},
  {'id': 'card', 'label': 'Card'},
  {'id': 'bkash', 'label': 'bKash'},
];

/// Mirrors app/checkout/page.jsx — delivery details form, order summary,
/// server-computed total (we only ever send product ids/quantities).
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orderService = OrderService();

  final _fullName = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _postalCode = TextEditingController();
  final _phone = TextEditingController();
  final _note = TextEditingController();
  String _paymentMethod = 'cash';

  bool _submitting = false;
  String? _error;
  FoodOrder? _placed;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final order = await _orderService.placeOrder(
        fullName: _fullName.text.trim(),
        address: _address.text.trim(),
        city: _city.text.trim(),
        postalCode: _postalCode.text.trim(),
        phone: _phone.text.trim(),
        note: _note.text.trim(),
        paymentMethod: _paymentMethod,
        products: cart.items.map((i) => {'product_id': i.id, 'quantity': i.quantity}).toList(),
      );
      cart.clearCart();
      setState(() => _placed = order);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _address.dispose();
    _city.dispose();
    _postalCode.dispose();
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    final cart = context.watch<CartProvider>();

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: EmptyState(
          title: 'Sign in to check out',
          subtitle: "Create an account or sign in so we can attach this order to you and track it.",
          action: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
            child: const Text('Sign in'),
          ),
        ),
      );
    }

    if (_placed != null) {
      final placed = _placed!;
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.ember500, size: 72),
                const SizedBox(height: 20),
                const Text('Order placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.ink950)),
                const SizedBox(height: 10),
                Text(
                  'Order #${placed.orderNumber} is being prepared. You can track its status from your account.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const RootShell(initialIndex: 3)),
                        (route) => false,
                      ),
                      child: const Text('Track order'),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MenuScreen()),
                        (route) => false,
                      ),
                      child: const Text('Order more'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: EmptyState(
          title: 'Your cart is empty',
          subtitle: 'Add something tasty from the menu before checking out.',
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
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Delivery details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            TextFormField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full name'), validator: _req),
            const SizedBox(height: 12),
            TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: _req),
            const SizedBox(height: 12),
            TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address'), validator: _req),
            const SizedBox(height: 12),
            TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'), validator: _req),
            const SizedBox(height: 12),
            TextFormField(controller: _postalCode, decoration: const InputDecoration(labelText: 'Postal code'), validator: _req),
            const SizedBox(height: 12),
            TextFormField(controller: _note, decoration: const InputDecoration(labelText: 'Delivery note (optional)'), maxLines: 3),
            const SizedBox(height: 18),
            const Text('Payment method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black54)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _paymentMethods.map((m) {
                final selected = _paymentMethod == m['id'];
                return ChoiceChip(
                  label: Text(m['label']!),
                  selected: selected,
                  onSelected: (_) => setState(() => _paymentMethod = m['id']!),
                  selectedColor: AppColors.ember50,
                  labelStyle: TextStyle(color: selected ? AppColors.ember700 : Colors.black87, fontWeight: FontWeight.w700),
                  side: BorderSide(color: selected ? AppColors.ember500 : const Color(0x1A0B0A08)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 14)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 10),
                  ...cart.items.map((i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('${i.quantity} × ${i.name}', style: const TextStyle(color: Colors.black54, fontSize: 13))),
                            Text('\$${(i.currentPrice * i.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery fee', style: TextStyle(color: Colors.black54)),
                      Text('\$${deliveryFee.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                      Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.ember600)),
                    ],
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.ember700, fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? 'Placing order…' : 'Place order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
}
