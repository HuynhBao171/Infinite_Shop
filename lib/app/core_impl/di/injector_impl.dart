import 'package:infinite_shop/app/core_impl/di/injector_config.dart';
import 'package:infinite_shop/app/core_impl/local_storage/hive_local_storage_impl.dart';
import 'package:infinite_shop/app/core_impl/logger/logger_impl.dart';
import 'package:infinite_shop/core/arch/data/network/base_api_service.dart';
import 'package:infinite_shop/core/arch/domain/repository/base_repository.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';
import 'package:infinite_shop/core/arch/presentation/controller/base_controller.dart';
import 'package:infinite_shop/core/di/injector.dart';
import 'package:infinite_shop/core/local_storage/local_storage.dart';
import 'package:infinite_shop/core/logger/app_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Shortcut for dependency injection manager.
final inj = InjectorImpl();

/// Shortcut for logger manager.
AppLogger get log => inj.logger;

/// Implementation of the [Injector].
class InjectorImpl extends Injector {
  @override
  Future<void> initialize() async {
    /// App env & util initialization
    await _injectLocalizations();
    await _injectLogger();
    await _injectEnv();

    /// Inject data layer
    await _injectLocalStorage();
    await _injectApiServices();

    /// Inject domain layer
    await _injectRepositories();
    await _injectUseCases();

    /// Inject presentation layer
    await _injectGlobalStates();
  }

  @override
  Future<void> reset() async {
    await _injectGlobalStates();
  }

  /// Inject localizations
  Future<void> _injectLocalizations() async {
    await EasyLocalization.ensureInitialized();
  }

  /// Inject an implementation of Logger
  Future<void> _injectLogger() async {
    await registerSingleton<AppLogger>(Logger());
  }

  /// Injects environment variables
  Future<void> _injectEnv() async {
    await dotenv.load();
  }

  /// Injects local storage
  Future<void> _injectLocalStorage() async {
    // Initialize hive storage, an implementation of LocalStogare
    await Hive.initFlutter();

    // Open boxes
    await Hive.openBox<dynamic>(StorageBox.defaultX.name);
    await Hive.openBox<dynamic>(StorageBox.setting.name);

    // Inject an implementation of LocalStogare
    await registerSingleton<LocalStorage>(HiveLocalStorage());
    await get<LocalStorage>().migrate();
  }

  /// Inject API Service
  Future<void> _injectApiServices() async {
    for (final item in InjectorConfig.apiServiceFactories.entries) {
      await registerFactory<BaseApiService>(
        item.value,
        instanceName: item.key.toString(),
      );
    }
  }

  /// Inject repositories
  Future<void> _injectRepositories() async {
    for (final item in InjectorConfig.repositoryFactories.entries) {
      await registerFactory<BaseRepository>(
        item.value,
        instanceName: item.key.toString(),
      );
    }
  }

  /// Inject use cases
  Future<void> _injectUseCases() async {
    for (final item in InjectorConfig.useCaseFactories.entries) {
      await registerFactory<BaseUseCase<dynamic, dynamic>>(
        item.value,
        instanceName: item.key.toString(),
      );
    }
  }

  /// Inject global states
  Future<void> _injectGlobalStates() async {
    for (final item in InjectorConfig.globalControllerFactories.entries) {
      await registerLazySingleton<BaseController>(
        item.value.factory,
        instanceName: item.key.toString(),
        resetable: item.value.resetable,
      );
    }
  }
}
