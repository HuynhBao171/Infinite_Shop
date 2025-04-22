import 'package:infinite_shop/core/local_storage/local_storage.dart';

typedef Key<T> = LocalStorageKey<T>;

/// Extension on [LocalStorageKey] that provides predefined keys for common and core data.
extension LocalStorageKeyPredefined on LocalStorageKey {
  /// Common data
  static const localStorageVersion = Key<int>('local_storage_version');

  /// Favorite products
  static const favoriteProducts = Key<List<String>>('favorite_products');
}
