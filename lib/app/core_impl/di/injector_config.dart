import 'package:infinite_shop/app/layers/data/repositories_impl/product/product_repository_impl.dart';
import 'package:infinite_shop/app/layers/data/sources/network/app_api_service.dart';
import 'package:infinite_shop/app/layers/domain/repositories/product/product_repository.dart';
import 'package:infinite_shop/app/layers/domain/usecases/product/fetch_product_usecase.dart';
import 'package:infinite_shop/app/layers/domain/usecases/product/fetch_products_usecase.dart';
import 'package:infinite_shop/app/layers/domain/usecases/product/search_products_usecase.dart';
import 'package:infinite_shop/app/layers/presentation/components/pages/home/home_controller.dart';
import 'package:infinite_shop/app/layers/presentation/global_controllers/app/app_controller.dart';
import 'package:infinite_shop/app/layers/presentation/global_controllers/setting/setting_controller.dart';
import 'package:infinite_shop/core/arch/data/network/base_api_service.dart';
import 'package:infinite_shop/core/arch/domain/repository/base_repository.dart';
import 'package:infinite_shop/core/arch/domain/usecase/base_usecase.dart';
import 'package:infinite_shop/core/arch/presentation/controller/base_controller.dart';

/// Configuration for the dependency injection.
class InjectorConfig {
  /// Declare all the api services here for the dependency injection.
  static const Map<Type, BaseApiService Function()> apiServiceFactories = {
    AppApiService: AppApiServiceImpl.new,
  };

  /// Declare all the repositories here for the dependency injection.
  static const Map<Type, BaseRepository Function()> repositoryFactories = {
    ProductRepository: ProductRepositoryImpl.new,
  };

  /// Declare all the global controllers here for the dependency injection.
  /// { factory: resetable }
  /// resetable: true - the controller will be reinitialized when logout
  static const Map<Type, ({BaseController Function() factory, bool resetable})>
  globalControllerFactories = {
    AppController: (factory: AppController.new, resetable: true),
    SettingController: (factory: SettingController.new, resetable: true),
    HomeController: (factory: HomeController.new, resetable: true),
  };

  /// Declare all the use cases here for the dependency injection.
  static const Map<Type, BaseUseCase<dynamic, dynamic> Function()>
  useCaseFactories = {
    FetchProductUseCase: FetchProductUseCase.new,
    FetchProductsUseCase: FetchProductsUseCase.new,
    SearchProductsUseCase: SearchProductsUseCase.new,
  };
}
