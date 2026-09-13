import '../models/food.dart';
import 'api_client.dart';

/// Mirrors the Foods section of frontend/lib/api.js exactly.
class FoodService {
  final _dio = ApiClient.instance.dio;

  Future<List<Food>> getFoods() => guardApi(() async {
        final res = await _dio.get('/foods');
        return (res.data as List).map((e) => Food.fromJson(e as Map<String, dynamic>)).toList();
      });

  Future<Food> getFoodById(String id) => guardApi(() async {
        final res = await _dio.get('/foods/$id');
        return Food.fromJson(res.data as Map<String, dynamic>);
      });

  /// admin only (requireAuth + requireAdmin on the backend)
  Future<Food> addFood(Map<String, dynamic> payload) => guardApi(() async {
        final res = await _dio.post('/foods/add', data: payload);
        return Food.fromJson(res.data as Map<String, dynamic>);
      });

  /// admin only
  Future<Food> updateFood(String id, Map<String, dynamic> payload) => guardApi(() async {
        final res = await _dio.put('/foods/update/$id', data: payload);
        return Food.fromJson(res.data as Map<String, dynamic>);
      });

  /// admin only
  Future<void> deleteFood(String id) => guardApi(() async {
        await _dio.delete('/foods/delete/$id');
      });
}
