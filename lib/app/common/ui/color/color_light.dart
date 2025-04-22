import 'package:infinite_shop/app/common/ui/color/app_color.dart';
import 'package:infinite_shop/app/common/util/extension/string/string_to_color.dart';
import 'package:flutter/material.dart';

/// A class that defines the light color scheme for the app.
class LightAppColor extends AppColor {
  @override
  Color get primaryBackground => const Color(0xFFE4DED5);

  @override
  Color get accentColor => '#E0C0CC'.toColor;

  @override
  Color get containerBackground => '#BDBDBD'.toColor;

  @override
  Color get sheetColor => '#D5D2D2'.toColor;

  @override
  Color get snackBarColor => '#55555555'.toColor;

  @override
  Color get subTextColor => '#B3000000'.toColor;

  @override
  Color get warningTextColor => '#F4ADAD'.toColor;

  @override
  Color get errorTextColor => '#FF5252'.toColor;

  @override
  Color get textColor => Colors.black;

  @override
  List<Color> get backgroundGradientColors => [
        const Color(0xFFE4FDEC),
        const Color(0xFFCBE0FC),
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
