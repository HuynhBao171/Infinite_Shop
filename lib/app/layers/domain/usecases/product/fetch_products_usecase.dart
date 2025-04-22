import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/domain/repositories/product/product_repository.dart';
import 'package:infinite_shop/core/arch/domain/repository/repository_provider.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';

/// Fetch products usecase
class FetchProductsUseCase
    extends
        BaseUseCase<FetchProductsUseCaseRequest, FetchProductsUseCaseResponse>
    with RepositoryProvider {
  /// Default constructor for the FetchProductsUseCase.
  FetchProductsUseCase();

  @override
  Future<FetchProductsUseCaseResponse> execute(
    FetchProductsUseCaseRequest request,
  ) async {
    return repository<ProductRepository>()
        .fetchProducts(
          limit: request.limit,
          skip: request.skip,
          search: request.search,
        )
        .then((products) => FetchProductsUseCaseResponse(products: products));
  }
}

/// Request for the Fetch products usecase
class FetchProductsUseCaseRequest {
  /// Default constructor for the FetchProductsUseCaseRequest.
  FetchProductsUseCaseRequest({this.limit, this.skip, this.search});

  final int? limit;
  final int? skip;
  final String? search;
}

/// Response for the Fetch products usecase
class FetchProductsUseCaseResponse {
  /// Default constructor for the FetchProductsResponse.
  FetchProductsUseCaseResponse({this.products});

  final List<Product>? products;
}
