import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/domain/repositories/product/product_repository.dart';
import 'package:infinite_shop/core/arch/domain/repository/repository_provider.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';

/// Search products usecase
class SearchProductsUseCase
    extends
        BaseUseCase<SearchProductsUseCaseRequest, SearchProductsUseCaseResponse>
    with RepositoryProvider {
  /// Default constructor for the SearchProductsUseCase.
  SearchProductsUseCase();

  @override
  Future<SearchProductsUseCaseResponse> execute(
    SearchProductsUseCaseRequest request,
  ) async {
    return repository<ProductRepository>()
        .searchProducts(request.query)
        .then((products) => SearchProductsUseCaseResponse(products: products));
  }
}

/// Request for the Search products usecase
class SearchProductsUseCaseRequest {
  /// Default constructor for the SearchProductsUseCaseRequest.
  SearchProductsUseCaseRequest({required this.query});

  final String query;
}

/// Response for the Search products usecase
class SearchProductsUseCaseResponse {
  /// Default constructor for the SearchProductsResponse.
  SearchProductsUseCaseResponse({this.products});

  final List<Product>? products;
}
