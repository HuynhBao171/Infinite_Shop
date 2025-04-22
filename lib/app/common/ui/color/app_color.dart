import 'package:flutter/material.dart';

/// An abstract class that defines the color scheme of the app.
abstract class AppColor {
  /// The primary background color.
  Color get primaryBackground;

  /// The accent color.
  Color get accentColor;

  /// The container background color.
  Color get containerBackground;

  /// The color of the sheet.
  Color get sheetColor;

  /// The color of the snackbar.
  Color get snackBarColor;

  /// The text color.
  Color get textColor;

  /// The error text color.
  Color get errorTextColor;

  /// The subtext color.
  Color get subTextColor;

  /// The warning text color.
  Color get warningTextColor;

  Color get borderProcess;

  Color get colorProcess;

  Color get bgProductPage;

  Color get iconTabProduct;

  /// The common gradient colors.
  List<Color> get commonGradientColors => [
        const Color(0xFFDBC1CB),
        const Color(0xFFC8C0D2),
      ];

  /// The background gradient colors.
  List<Color> get backgroundGradientColors => [
        const Color(0xFFE4FDEC),
        const Color(0xFFCBE0FC),
      ];
}
