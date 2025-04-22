import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/core/arch/domain/repository/base_repository.dart';

/// Repository for the product_repository
abstract class ProductRepository extends BaseRepository {
  /// Fetches a product based on the given [id].
  Future<Product?> fetchProduct(String id);

  /// Fetches a list of products.
  Future<List<Product>?> fetchProducts({int? limit, int? skip, String? search});

  /// Searches for products based on the given [query].
  Future<List<Product>?> searchProducts(String query);
}
