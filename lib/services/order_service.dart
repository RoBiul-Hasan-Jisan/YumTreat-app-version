import '../models/order.dart';
import 'api_client.dart';

class OrdersPage {
  final List<FoodOrder> orders;
  final int page;
  final int limit;
  final int total;
  final int pages;

  OrdersPage({
    required this.orders,
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
}

/// Mirrors the Orders section of frontend/lib/api.js exactly.
class OrderService {
  final _dio = ApiClient.instance.dio;

  /// POST /orders/place — server recomputes prices/total from live Food
  /// data; we only ever send product ids + quantities, never a total.
  Future<FoodOrder> placeOrder({
    required String fullName,
    required String address,
    required String city,
    required String postalCode,
    required String phone,
    required String note,
    required String paymentMethod, // cash | card | bkash
    required List<Map<String, dynamic>> products, // [{product_id, quantity}]
  }) =>
      guardApi(() async {
        final res = await _dio.post('/orders/place', data: {
          'fullName': fullName,
          'address': address,
          'city': city,
          'postalCode': postalCode,
          'phone': phone,
          'note': note,
          'paymentMethod': paymentMethod,
          'products': products,
        });
        return FoodOrder.fromJson(res.data as Map<String, dynamic>);
      });

  Future<List<FoodOrder>> getMyOrders() => guardApi(() async {
        final res = await _dio.get('/orders/my-orders');
        return (res.data as List).map((e) => FoodOrder.fromJson(e as Map<String, dynamic>)).toList();
      });

  /// admin only. filters: status, search, from, to, page, limit, sort
  Future<OrdersPage> getAllOrders({
    String? status,
    String? search,
    String? sort,
    int page = 1,
    int limit = 10,
  }) =>
      guardApi(() async {
        final res = await _dio.get('/orders/admin', queryParameters: {
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
          if (sort != null) 'sort': sort,
          'page': page,
          'limit': limit,
        });
        final data = res.data as Map<String, dynamic>;
        final pagination = data['pagination'] as Map<String, dynamic>;
        return OrdersPage(
          orders: (data['orders'] as List).map((e) => FoodOrder.fromJson(e as Map<String, dynamic>)).toList(),
          page: (pagination['page'] as num).toInt(),
          limit: (pagination['limit'] as num).toInt(),
          total: (pagination['total'] as num).toInt(),
          pages: (pagination['pages'] as num).toInt(),
        );
      });

  /// admin only
  Future<OrderStats> getOrderStats() => guardApi(() async {
        final res = await _dio.get('/orders/admin/stats');
        return OrderStats.fromJson(res.data as Map<String, dynamic>);
      });

  /// admin only
  Future<FoodOrder> updateOrderStatus(String id, String status, {String? cancelReason}) => guardApi(() async {
        final res = await _dio.patch('/orders/update-status/$id', data: {
          'status': status,
          if (cancelReason != null) 'cancelReason': cancelReason,
        });
        return FoodOrder.fromJson(res.data as Map<String, dynamic>);
      });

  /// customer cancels their own order (only while status == preparing)
  Future<FoodOrder> cancelOrder(String id, {String? reason}) => guardApi(() async {
        final res = await _dio.patch('/orders/cancel/$id', data: {if (reason != null) 'reason': reason});
        return FoodOrder.fromJson(res.data as Map<String, dynamic>);
      });

  /// customer confirms receipt (only while status == delivered)
  Future<FoodOrder> completeOrder(String id) => guardApi(() async {
        final res = await _dio.patch('/orders/complete/$id');
        return FoodOrder.fromJson(res.data as Map<String, dynamic>);
      });
}
