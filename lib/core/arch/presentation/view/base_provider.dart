import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';
import 'package:infinite_shop/core/arch/presentation/controller/base_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// BaseProvider is a generic widget that combines [Provider] with a provided
/// [BaseController] instance to provide the controller to child widgets.
///
/// It takes a [child] widget that will have access to the controller instance
/// via [Provider.of]. The controller type `T` must extend [BaseController].
///
/// The controller instance [ctrl] is passed as a parameter to the constructor.
///
/// In the [build] method, it simply uses [Provider] to make [ctrl]
/// available to descendants.
class BaseProvider<T extends BaseController> extends StatelessWidget {
  /// Default constructor.
  const BaseProvider({required this.ctrl, required this.child, super.key});

  /// The controller instance.
  final T ctrl;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        log.debug('[${ctrl.runtimeType}] Init!');
        return ctrl;
      },
      child: child,
      dispose: (context, value) async {
        log.debug('[${ctrl.runtimeType}] Start disposing!');
        await value.onDispose();
        log.debug('[${ctrl.runtimeType}] Disposed!');
      },
    );
  }
}
