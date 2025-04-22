import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/domain/repositories/product/product_repository.dart';
import 'package:infinite_shop/core/arch/domain/repository/repository_provider.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';

/// Fetch product usecase usecase
class FetchProductUseCase
    extends BaseUseCase<FetchProductUseCaseRequest, FetchProductUseCaseResponse>
    with RepositoryProvider {
  /// Default constructor for the FetchProductUseCaseUseCase.
  FetchProductUseCase();

  @override
  Future<FetchProductUseCaseResponse> execute(
    FetchProductUseCaseRequest request,
  ) async {
    return repository<ProductRepository>()
        .fetchProduct(request.id)
        .then((product) => FetchProductUseCaseResponse(product: product));
  }
}

/// Request for the Fetch product usecase usecase
class FetchProductUseCaseRequest {
  /// Default constructor for the FetchProductUseCaseRequest.
  FetchProductUseCaseRequest({required this.id});

  /// The user input prompt
  final String id;
}

/// Response for the Fetch product usecase usecase
class FetchProductUseCaseResponse {
  /// Default constructor for the FetchProductUseCaseResponse.
  FetchProductUseCaseResponse({this.product});

  /// The generated text based on the user input prompt
  final Product? product;
}
