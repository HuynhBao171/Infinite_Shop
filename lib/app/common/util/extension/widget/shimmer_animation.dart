import 'package:infinite_shop/app/common/util/extension/build_context/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Extension on [Widget] to add shimmer animation.
extension ShimmerAnimationExt on Widget {
  /// Adds shimmer animation to the widget.
  Widget get shimmerAnimation => Builder(
        builder: (context) {
          return animate(
            onPlay: (controller) => controller.repeat(), // Loop the animation
          ).shimmer(duration: 2000.ms, color: context.color.primaryBackground);
        },
      );
}
