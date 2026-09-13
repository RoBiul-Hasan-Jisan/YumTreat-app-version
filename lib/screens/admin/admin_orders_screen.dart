import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'admin_guard.dart';

/// Mirrors app/admin/orders/page.jsx — filter by status/search, paginate,
/// update order status (with a cancel-reason prompt).
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminGuard(child: _OrdersManager());
  }
}

class _OrdersManager extends StatefulWidget {
  const _OrdersManager();

  @override
  State<_OrdersManager> createState() => _OrdersManagerState();
}

class _OrdersManagerState extends State<_OrdersManager> {
  final _orderService = OrderService();
  final _searchController = TextEditingController();

  List<FoodOrder> _orders = [];
  String _status = 'loading';
  String? _filterStatus;
  int _page = 1;
  int _pages = 1;
  String? _busyId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = 'loading');
    try {
      final result = await _orderService.getAllOrders(
        status: _filterStatus,
        search: _searchController.text.trim(),
        page: _page,
        sort: '-createdAt',
      );
      setState(() {
        _orders = result.orders;
        _pages = result.pages;
        _status = 'ready';
      });
    } catch (_) {
      setState(() => _status = 'error');
    }
  }

  Future<void> _updateStatus(FoodOrder order, String newStatus) async {
    String? cancelReason;
    if (newStatus == OrderStatus.cancel) {
      cancelReason = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Cancel this order?'),
            content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Reason (optional)')),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
              TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Confirm cancel')),
            ],
          );
        },
      );
      if (cancelReason == null) return; // dialog dismissed
    }
    setState(() => _busyId = order.id);
    try {
      final updated = await _orderService.updateOrderStatus(order.id, newStatus, cancelReason: cancelReason);
      setState(() => _orders = _orders.map((o) => o.id == order.id ? updated : o).toList());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All orders')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) {
                _page = 1;
                _load();
              },
              decoration: InputDecoration(
                hintText: 'Search by name, phone, or order #',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () { _page = 1; _load(); }),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip(null, 'All'),
                ...OrderStatus.all.map((s) => Padding(padding: const EdgeInsets.only(left: 8), child: _filterChip(s, OrderStatus.label(s)))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Builder(builder: (context) {
              if (_status == 'loading') return const Loader(label: 'Loading orders…');
              if (_status == 'error') return ErrorState(message: "Couldn't load orders.", onRetry: _load);
              if (_orders.isEmpty) return const EmptyState(title: 'No orders found', subtitle: 'Try a different filter.');
              return RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _AdminOrderCard(
                    order: _orders[i],
                    busy: _busyId == _orders[i].id,
                    onStatusChange: (s) => _updateStatus(_orders[i], s),
                  ),
                ),
              );
            }),
          ),
          if (_pages > 1)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _page > 1 ? () { setState(() => _page--); _load(); } : null,
                  ),
                  Text('Page $_page of $_pages'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _page < _pages ? () { setState(() => _page++); _load(); } : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterChip(String? status, String label) {
    final selected = _filterStatus == status;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _filterStatus = status;
          _page = 1;
        });
        _load();
      },
      selectedColor: AppColors.ember50,
      labelStyle: TextStyle(color: selected ? AppColors.ember700 : Colors.black87, fontWeight: FontWeight.w700),
      side: BorderSide(color: selected ? AppColors.ember500 : const Color(0x1A0B0A08)),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final FoodOrder order;
  final bool busy;
  final ValueChanged<String> onStatusChange;

  const _AdminOrderCard({required this.order, required this.busy, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${order.orderNumber} · ${order.fullName}', style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(order.phone, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                  ],
                ),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('${order.address}, ${order.city} ${order.postalCode}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          ...order.products.map((p) => Text('${p.quantity}× ${p.name}', style: const TextStyle(fontSize: 12, color: Colors.black54))),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$${order.payed.toStringAsFixed(2)} · ${order.paymentMethod}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              if (busy)
                const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              else
                DropdownButton<String>(
                  value: order.status,
                  underline: const SizedBox(),
                  items: OrderStatus.all.map((s) => DropdownMenuItem(value: s, child: Text(OrderStatus.label(s), style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) {
                    if (v != null && v != order.status) onStatusChange(v);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
