import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';
import 'package:infinite_shop/core/arch/domain/repository/base_repository.dart';

/// A mixin that provides access to repository instances.
mixin RepositoryProvider {
  /// Returns the repository instance of type [T].
  ///
  /// The type parameter [T] should extend [BaseRepository].
  /// This method uses the `inj.get()` function to retrieve the repo instance.
  T repository<T extends BaseRepository>() => inj.get<BaseRepository>(
        instanceName: T.toString(),
      ) as T;
}
