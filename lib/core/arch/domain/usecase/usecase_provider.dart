import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';

/// A mixin that provides a method for accessing use cases.
mixin UseCaseProvider {
  /// Returns an instance of the use case of type [T].
  ///
  /// The type parameter [T] should extend [BaseUseCase].
  /// Returns the repository instance of type [T].
  T usecase<T extends BaseUseCase<dynamic, dynamic>>() =>
      inj.get<BaseUseCase<dynamic, dynamic>>(instanceName: T.toString()) as T;
}
