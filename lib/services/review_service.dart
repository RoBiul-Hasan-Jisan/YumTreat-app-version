import '../models/review.dart';
import 'api_client.dart';

class ReviewService {
  final _dio = ApiClient.instance.dio;

  Future<List<Review>> getReviewsByProduct(String productId) => guardApi(() async {
        final res = await _dio.get('/reviews/product/$productId');
        return (res.data as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
      });

  Future<List<Review>> getReviewsByUser(String userId) => guardApi(() async {
        final res = await _dio.get('/reviews/user/$userId');
        return (res.data as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
      });

  /// Uses the /add-review alias, same as ReviewsPanel.jsx on the website.
  /// NOTE: the website's review form (on a food's detail page) only ever
  /// sends productID/rating/feedback, no orderID — mirrored here as-is.
  /// The backend controller technically requires orderID too, so calls
  /// without one will 400 there exactly as they do on the live site.
  Future<Review> addReview({
    String? orderId,
    required String productId,
    required int rating,
    required String feedback,
  }) =>
      guardApi(() async {
        final res = await _dio.post('/reviews/add-review', data: {
          if (orderId != null) 'orderID': orderId,
          'productID': productId,
          'rating': rating,
          'feedback': feedback,
        });
        return Review.fromJson(res.data as Map<String, dynamic>);
      });
}
