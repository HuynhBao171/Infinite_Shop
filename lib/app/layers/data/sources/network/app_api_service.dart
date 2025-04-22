import 'package:infinite_shop/app/common/app_config.dart';
import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/core/arch/data/network/base_api_service.dart';

/// API service for the application.
abstract class AppApiService extends BaseApiService {
  /// Fetches a products.
  Future<List<Product>?> fetchProducts({int? limit, int? skip, String? search});

  /// Fetches a product.
  Future<Product?> fetchProduct(String id);

  /// Searches for products.
  Future<List<Product>?> searchProducts(String query);
}

/// Implementation of the [AppApiService] class.
class AppApiServiceImpl extends AppApiService {
  @override
  String get baseUrl => AppConfig.apiHost;

  @override
  Map<String, String> get headers => {};

  @override
  Future<List<Product>?> fetchProducts({
    int? limit,
    int? skip,
    String? search,
  }) async => performGet(
    '/products',
    query: {'limit': limit, 'skip': skip, 'search': search},
    decoder: (data) {
      if (data is Map<String, dynamic> && data.containsKey('products')) {
        final productsList = data['products'] as List;
        return productsList
            .map((item) {
              try {
                return Product.fromJson(item as Map<String, dynamic>);
              } catch (e) {
                // Skip invalid items
                print('Error parsing product: $e');
                return null;
              }
            })
            .whereType<Product>() // Keep only successfully parsed products
            .toList();
      }
      return null;
    },
  );

  @override
  Future<Product?> fetchProduct(String id) async => performGet(
    '/products/$id',
    decoder: (data) {
      try {
        return Product.fromJson(data as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing product detail: $e');
        return null;
      }
    },
  );

  @override
  Future<List<Product>?> searchProducts(String query) async => performGet(
    '/products/search',
    query: {'q': query},
    decoder: (data) {
      if (data is Map<String, dynamic> && data.containsKey('products')) {
        final productsList = data['products'] as List;
        return productsList
            .map((item) {
              try {
                return Product.fromJson(item as Map<String, dynamic>);
              } catch (e) {
                // Skip invalid items
                print('Error parsing search product: $e');
                return null;
              }
            })
            .whereType<Product>() // Keep only successfully parsed products
            .toList();
      }
      return null;
    },
  );
}
