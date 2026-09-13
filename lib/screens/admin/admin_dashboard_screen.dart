import 'package:flutter/material.dart';

import '../../services/food_service.dart';
import '../../services/order_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'admin_foods_screen.dart';
import 'admin_guard.dart';
import 'admin_orders_screen.dart';

/// Mirrors app/admin/page.jsx — stat cards + shortcuts to menu/orders mgmt.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminGuard(child: _AdminOverview());
  }
}

class _AdminOverview extends StatefulWidget {
  const _AdminOverview();

  @override
  State<_AdminOverview> createState() => _AdminOverviewState();
}

class _AdminOverviewState extends State<_AdminOverview> {
  final _foodService = FoodService();
  final _orderService = OrderService();

  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([_foodService.getFoods(), _orderService.getOrderStats()]);
      final foods = results[0] as List;
      final orderStats = results[1] as dynamic;
      setState(() {
        _stats = {
          'foods': foods.length,
          'orders': orderStats.totalOrders,
          'revenue': orderStats.totalRevenue,
          'pending': orderStats.statusCounts['preparing'] ?? 0,
        };
      });
    } catch (_) {
      // leave stats null; cards just won't render
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Welcome back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink950)),
            const SizedBox(height: 4),
            const Text('Manage the menu and keep on top of incoming orders.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            if (_stats == null)
              const Loader(label: 'Loading dashboard…')
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(icon: Icons.grid_view_rounded, label: 'Menu items', value: '${_stats!['foods']}'),
                  _StatCard(icon: Icons.inventory_2_outlined, label: 'Total orders', value: '${_stats!['orders']}'),
                  _StatCard(icon: Icons.hourglass_bottom, label: 'Orders in progress', value: '${_stats!['pending']}'),
                  _StatCard(icon: Icons.attach_money, label: 'Revenue tracked', value: '\$${(_stats!['revenue'] as num).toStringAsFixed(2)}'),
                ],
              ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('Manage menu items', style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('Add, edit, or remove dishes from the live menu.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.ember600),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminFoodsScreen())),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Manage orders', style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('Update order status as it moves through the kitchen.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.ember600),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminOrdersScreen())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.ember50, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 16, color: AppColors.ember600),
            ),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.ink950)),
            Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}
