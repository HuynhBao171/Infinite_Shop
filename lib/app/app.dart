import 'package:infinite_shop/app/layers/presentation/components/pages/home/home_page.dart';
import 'package:infinite_shop/app/layers/presentation/components/pages/home/home_controller.dart';
import 'package:infinite_shop/core/arch/presentation/view/base_provider.dart';
import 'package:infinite_shop/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The root widget of the application.
class App extends StatelessWidget {
  /// Default constructor.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size based on a typical mobile device
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: F.title,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: BaseProvider(ctrl: HomeController(), child: HomePage()),
        );
      },
    );
  }
}
