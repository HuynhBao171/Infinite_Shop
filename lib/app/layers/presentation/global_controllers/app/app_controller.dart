import 'dart:async';

import 'package:infinite_shop/core/arch/domain/usecase/usecase_provider.dart';
import 'package:infinite_shop/core/arch/presentation/controller/base_controller.dart';

/// Controller for the global app state
class AppController extends BaseController with UseCaseProvider {
  /// AppController constructor
  AppController();

  @override
  FutureOr<void> onDispose() async {}
}
