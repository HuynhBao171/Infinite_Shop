import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:infinite_shop/app/app.dart';
import 'package:infinite_shop/app/core_impl/di/injector_impl.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await inj.initialize();

  // Run app
  runApp(const App());
}
