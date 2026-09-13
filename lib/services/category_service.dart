import '../models/category.dart';
import 'api_client.dart';

class CategoryService {
  final _dio = ApiClient.instance.dio;

  Future<List<FoodCategory>> getCategories() => guardApi(() async {
        final res = await _dio.get('/categories');
        return (res.data as List).map((e) => FoodCategory.fromJson(e as Map<String, dynamic>)).toList();
      });
}
