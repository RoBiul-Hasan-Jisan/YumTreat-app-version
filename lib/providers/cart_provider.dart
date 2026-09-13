import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food.dart';

class CartItem {
  final String id; // food._id
  final String name;
  final String imageUrl;
  final double currentPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'imageUrl': imageUrl,
        'currentPrice': currentPrice,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['_id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String? ?? '',
        currentPrice: (json['currentPrice'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
      );
}

/// Mirrors frontend/context/CartContext.jsx, but persists via
/// SharedPreferences instead of window.localStorage.
class CartProvider extends ChangeNotifier {
  static const _storageKey = 'yumtreat_cart';

  List<CartItem> items = [];
  bool hydrated = false;

  CartProvider() {
    _hydrate();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        items = list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        // ignore malformed cache
      }
    }
    hydrated = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  double get subtotal => items.fold(0, (sum, i) => sum + i.currentPrice * i.quantity);
  int get totalCount => items.fold(0, (sum, i) => sum + i.quantity);

  void addItem(Food food, {int qty = 1}) {
    final idx = items.indexWhere((i) => i.id == food.id);
    if (idx >= 0) {
      items[idx].quantity += qty;
    } else {
      items.add(CartItem(
        id: food.id,
        name: food.name,
        imageUrl: food.imageUrl,
        currentPrice: food.currentPrice,
        quantity: qty,
      ));
    }
    _persist();
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((i) => i.id == id);
    _persist();
    notifyListeners();
  }

  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      items.removeWhere((i) => i.id == id);
    } else {
      final idx = items.indexWhere((i) => i.id == id);
      if (idx >= 0) items[idx].quantity = quantity;
    }
    _persist();
    notifyListeners();
  }

  void clearCart() {
    items = [];
    _persist();
    notifyListeners();
  }
}
