import 'package:infinite_shop/app/common/ui/color/app_color.dart';
import 'package:infinite_shop/app/common/util/extension/string/string_to_color.dart';
import 'package:flutter/material.dart';

/// A class that defines the dark theme colors for the app.
class DarkAppColor extends AppColor {
  @override
  Color get primaryBackground => '#131314'.toColor;

  @override
  Color get accentColor => '#E0C0CC'.toColor;

  @override
  Color get containerBackground => '#1E1E20'.toColor;

  @override
  Color get sheetColor => '#171717'.toColor;

  @override
  Color get snackBarColor => '#55555555'.toColor;

  @override
  Color get textColor => '#FFFFFF'.toColor;

  @override
  Color get errorTextColor => '#FF5252'.toColor;

  @override
  Color get subTextColor => '#B3FFFFFF'.toColor;

  @override
  Color get warningTextColor => '#F4ADAD'.toColor;

  @override
  List<Color> get backgroundGradientColors => [
        const Color(0xFF131314),
        const Color(0xFF1E1E20),
      ];

  @override
  Color get borderProcess => '#E5E5E5'.toColor;

  @override
  Color get colorProcess => '#1A202C'.toColor;

  @override
  Color get bgProductPage => '#F3F3F3'.toColor;

  @override
  Color get iconTabProduct => '#717171'.toColor;
}
