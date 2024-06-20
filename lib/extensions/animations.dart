import 'package:flutter_animate/flutter_animate.dart';
import 'package:ludo/common_libs.dart';

extension WidgetAnimation on Widget {
  fadeInAndMoveFromTop({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? slowDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, -10))
          .fade(duration: animationDuration ?? fastDuration);

  fadeInAndMoveFromTopAndLeft({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
    Offset? offsetLeft,
  }) =>
      animate(delay: delay ?? slowDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, -10))
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offsetLeft ?? const Offset(-10, 0))
          .fade(duration: animationDuration ?? fastDuration);

  fadeInAndMoveFromTopAndRight({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
    Offset? offsetRight,
  }) =>
      animate(delay: delay ?? slowDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, -10))
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offsetRight ?? const Offset(10, 0))
          .fade(duration: animationDuration ?? fastDuration);

  fadeInAndMoveFromBottom({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? slowDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, 10))
          .fade(duration: animationDuration ?? fastDuration);

  fadeInAndMoveFromLeft({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? slowDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(-10, 0))
          .fade(duration: animationDuration ?? fastDuration);

  fadeIn({
    Duration? delay,
    Duration? animationDuration,
    Curve? curve,
  }) =>
      animate(delay: delay ?? slowDuration).fade(
          duration: animationDuration ?? fastDuration,
          curve: curve ?? Curves.decelerate);
}
