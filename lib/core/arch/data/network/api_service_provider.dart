import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';
import 'package:infinite_shop/core/arch/data/network/base_api_service.dart';

/// A mixin that provides access to API service instances.
mixin ApiServiceProvider {
  /// Returns the API service instance of type [T].
  ///
  /// The type parameter [T] should extend [BaseApiService].
  /// This method uses the `inj.get()` function to retrieve
  /// the API service instance.
  T apiService<T extends BaseApiService>() => inj.get<BaseApiService>(
        instanceName: T.toString(),
      ) as T;
}
