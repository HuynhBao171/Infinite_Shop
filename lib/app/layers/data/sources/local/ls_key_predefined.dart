import 'package:infinite_shop/core/local_storage/local_storage.dart';

/// Shortcut for [LocalStorageKey].
typedef LSKey<T> = LocalStorageKey<T>;

/// Extension on [LocalStorageKey] that provides predefined keys.
extension LSKeyPredefinedExt<T> on LocalStorageKey<T> {
  /// Common data
  static const localStorageVersion = LSKey<int>('local_storage_version');
}
