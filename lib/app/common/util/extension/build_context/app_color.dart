import 'package:infinite_shop/app/common/ui/color/app_color.dart';
import 'package:infinite_shop/app/common/util/extension/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// An ext for `BuildContext` that provides access to the app's color scheme.
extension AppColorExt on BuildContext {
  /// The app's color scheme.
  AppColor get color => appThemeExt(this).appColor;
}
