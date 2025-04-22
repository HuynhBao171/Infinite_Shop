import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';
import 'package:infinite_shop/core/local_storage/local_storage.dart';

/// A mixin that provides access to a [LocalStorage] instance.
///
/// This mixin provides a getter method `localStorage`
/// that returns an instance of [LocalStorage].
/// The [LocalStorage] instance is obtained through the
/// [InjectorImpl._injectLocalStorage] method, which is responsible for
/// managing dependencies in the application.
mixin LocalStorageProvider {
  /// Returns an instance of [LocalStorage] obtained through the
  /// [InjectorImpl._injectLocalStorage] method.
  LocalStorage get localStorage => inj.get();
}
