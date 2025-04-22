import 'package:infinite_shop/app/common/ui/color/color_dark.dart';
import 'package:infinite_shop/app/common/ui/color/color_light.dart';
import 'package:infinite_shop/app/common/ui/font/font.dart';
import 'package:infinite_shop/app/common/util/extension/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// A class that defines the app theme.
class AppTheme {
  /// The dark theme colors for the app.
  static final darkAppColor = DarkAppColor();

  /// The light theme colors for the app.
  static final lightAppColor = LightAppColor();

  /// The dark theme for the app.
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkAppColor.primaryBackground,
    textTheme: Typography().white.apply(fontFamily: Font.sFMono),
    extensions: [CustomThemeExt(appColor: darkAppColor)],
  );

  /// The light theme for the app.
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: lightAppColor.primaryBackground,
    textTheme: Typography().black.apply(fontFamily: Font.sFMono),
    extensions: [CustomThemeExt(appColor: lightAppColor)],
  );
}
