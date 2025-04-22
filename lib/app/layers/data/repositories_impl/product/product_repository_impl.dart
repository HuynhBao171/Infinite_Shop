import 'package:infinite_shop/app/layers/data/sources/network/app_api_service.dart';
import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/domain/repositories/product/product_repository.dart';
import 'package:infinite_shop/core/arch/data/network/api_service_provider.dart';

/// Implementation of the [ProductRepository] interface.
class ProductRepositoryImpl extends ProductRepository with ApiServiceProvider {
  @override
  Future<Product?> fetchProduct(String id) =>
      apiService<AppApiService>().fetchProduct(id);

  @override
  Future<List<Product>?> fetchProducts({
    int? limit,
    int? skip,
    String? search,
  }) => apiService<AppApiService>().fetchProducts(
    limit: limit,
    skip: skip,
    search: search,
  );

  @override
  Future<List<Product>?> searchProducts(String query) =>
      apiService<AppApiService>().searchProducts(query);
}
