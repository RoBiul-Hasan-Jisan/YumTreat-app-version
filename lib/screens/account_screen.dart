import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'about_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'contact_screen.dart';
import 'menu_screen.dart';
import 'signin_screen.dart';

/// Mirrors app/account/page.jsx — profile summary + order history with
/// live status, cancel (while preparing) and confirm-received (once
/// delivered) actions.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _orderService = OrderService();
  List<FoodOrder> _orders = [];
  String _status = 'loading';
  String? _busyId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.watch<AuthProvider>();
    if (auth.ready && auth.isAuthenticated && _status == 'loading' && _orders.isEmpty) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _status = 'loading');
    try {
      final orders = await _orderService.getMyOrders();
      setState(() {
        _orders = orders;
        _status = 'ready';
      });
    } catch (_) {
      setState(() => _status = 'error');
    }
  }

  Future<void> _cancel(String id) async {
    setState(() => _busyId = id);
    try {
      final updated = await _orderService.cancelOrder(id);
      setState(() => _orders = _orders.map((o) => o.id == id ? updated : o).toList());
    } catch (_) {
      // no-op, mirrors website's silent failure here
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _complete(String id) async {
    setState(() => _busyId = id);
    try {
      final updated = await _orderService.completeOrder(id);
      setState(() => _orders = _orders.map((o) => o.id == id ? updated : o).toList());
    } catch (_) {
      // no-op
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.ready) return const Scaffold(body: Loader());

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your account')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EmptyState(
              title: 'Sign in to view your account',
              subtitle: 'Track your orders, manage reviews, and see your order history.',
              action: ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
                child: const Text('Sign in'),
              ),
            ),
            const SizedBox(height: 24),
            _MoreLinks(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order history'),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 14)]),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: AppColors.ember50, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: AppColors.ember600),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auth.profile?.email ?? auth.firebaseUser?.email ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        Text('${auth.profile?.role ?? 'user'} account', style: const TextStyle(color: Colors.black45, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (auth.isAdmin) ...[
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.dashboard_outlined, color: AppColors.ember600),
                  title: const Text('Admin dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (_status == 'loading') const Loader(label: 'Loading your orders…'),
            if (_status == 'error') ErrorState(message: "Couldn't load your orders.", onRetry: _load),
            if (_status == 'ready' && _orders.isEmpty)
              EmptyState(
                title: 'No orders yet',
                subtitle: "Once you place an order it'll show up here with live status.",
                action: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MenuScreen())),
                  child: const Text('Browse the menu'),
                ),
              ),
            if (_status == 'ready')
              ..._orders.map((order) => _OrderCard(
                    order: order,
                    busy: _busyId == order.id,
                    onCancel: () => _cancel(order.id),
                    onComplete: () => _complete(order.id),
                  )),
            const SizedBox(height: 8),
            _MoreLinks(),
          ],
        ),
      ),
    );
  }
}

class _MoreLinks extends StatelessWidget {
  const _MoreLinks();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.ember600),
            title: const Text('About YumTreat'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.mail_outline, color: AppColors.ember600),
            title: const Text('Contact us'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactScreen())),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final FoodOrder order;
  final bool busy;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const _OrderCard({required this.order, required this.busy, required this.onCancel, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 14)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(color: Color(0x0D0B0A08), shape: BoxShape.circle),
                      child: const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(
                            '${order.createdAt != null ? order.createdAt.toString().split('.').first : ''} · ${order.products.length} item${order.products.length == 1 ? '' : 's'}',
                            style: const TextStyle(fontSize: 11, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          if (order.products.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...order.products.map((p) => Text('${p.quantity}× ${p.name}', style: const TextStyle(fontSize: 12, color: Colors.black54))),
          ],
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Deliver to ${order.address}, ${order.city} · Paid \$${order.payed.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
              ),
              if (order.status == OrderStatus.preparing)
                OutlinedButton(
                  onPressed: busy ? null : onCancel,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                  child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                ),
              if (order.status == OrderStatus.delivered && !order.isComplete)
                ElevatedButton(
                  onPressed: busy ? null : onComplete,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                  child: const Text('Confirm received', style: TextStyle(fontSize: 12)),
                ),
              if (order.isComplete)
                const Text('Completed ✓', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          if (order.status == OrderStatus.cancel && order.cancelReason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Reason: ${order.cancelReason}', style: const TextStyle(color: AppColors.ember700, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}
