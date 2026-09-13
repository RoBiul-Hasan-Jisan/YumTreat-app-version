/// Order line item — mirrors backend orderedProductSchema (snapshotted at order time).
class OrderedProduct {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  OrderedProduct({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> json) {
    return OrderedProduct(
      productId: json['product_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

/// One of: preparing, ready, out_for_delivery, delivered, cancel
class OrderStatus {
  static const preparing = 'preparing';
  static const ready = 'ready';
  static const outForDelivery = 'out_for_delivery';
  static const delivered = 'delivered';
  static const cancel = 'cancel';

  static const all = [preparing, ready, outForDelivery, delivered, cancel];

  static String label(String status) {
    switch (status) {
      case preparing:
        return 'Preparing';
      case ready:
        return 'Ready';
      case outForDelivery:
        return 'Out for delivery';
      case delivered:
        return 'Delivered';
      case cancel:
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Mirrors backend/src/models/Order.js
class FoodOrder {
  final String id;
  final String orderNumber;
  final String userId;
  final String fullName;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final String note;
  final List<OrderedProduct> products;
  final double subtotal;
  final double deliveryFee;
  final double payed;
  final String paymentMethod; // card | cash | bkash
  final String status;
  final String cancelReason;
  final bool isComplete;
  final DateTime? createdAt;

  FoodOrder({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.fullName,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.note,
    required this.products,
    required this.subtotal,
    required this.deliveryFee,
    required this.payed,
    required this.paymentMethod,
    required this.status,
    required this.cancelReason,
    required this.isComplete,
    this.createdAt,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['_id'] as String,
      orderNumber: json['orderNumber'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      note: json['note'] as String? ?? '',
      products: (json['products'] as List? ?? [])
          .map((e) => OrderedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 2.99,
      payed: (json['payed'] as num?)?.toDouble() ?? 0,
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      status: json['status'] as String? ?? OrderStatus.preparing,
      cancelReason: json['cancelReason'] as String? ?? '',
      isComplete: json['isComplete'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}

class OrderStats {
  final Map<String, int> statusCounts;
  final int totalOrders;
  final double totalRevenue;
  final int ordersToday;

  OrderStats({
    required this.statusCounts,
    required this.totalOrders,
    required this.totalRevenue,
    required this.ordersToday,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    final rawCounts = (json['statusCounts'] as Map<String, dynamic>? ?? {});
    return OrderStats(
      statusCounts: rawCounts.map((k, v) => MapEntry(k, (v as num).toInt())),
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      ordersToday: (json['ordersToday'] as num?)?.toInt() ?? 0,
    );
  }
}
