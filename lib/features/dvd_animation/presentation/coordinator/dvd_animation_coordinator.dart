import 'dart:ui';

import 'package:dvd_logo_animation/core/extensions/color_extension.dart';
import 'package:dvd_logo_animation/core/presentation/animation/bouncing_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_config.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_state.dart';
import 'package:injectable/injectable.dart';

typedef ColorFactory = Color Function();

@lazySingleton
class DvdAnimationCoordinator implements BouncingCoordinator<DvdLogoState> {
  DvdAnimationCoordinator({
    @ignoreParam ColorFactory? colorFactory,
    @ignoreParam Size? objectSize,
  }) : _colorFactory = colorFactory ?? _randomColor,
       _objectSize =
           objectSize ?? const Size(DvdLogoConfig.width, DvdLogoConfig.height);

  static Color _randomColor() => ColorX.random();

  final ColorFactory _colorFactory;
  final Size _objectSize;

  static const double _speed = 1.0;

  @override
  Size get objectSize => _objectSize;

  @override
  DvdLogoState initial({required Size screenSize}) => DvdLogoState(
    position: Offset(
      (screenSize.width - objectSize.width) / 2,
      (screenSize.height - objectSize.height) / 2,
    ),
    velocity: const Offset(_speed, -_speed),
    color: _colorFactory(),
  );

  @override
  DvdLogoState tick({required DvdLogoState current, required Size screenSize}) {
    var dx = current.velocity.dx;
    var dy = current.velocity.dy;
    var x = current.position.dx + dx;
    var y = current.position.dy + dy;
    var bounced = false;

    final maxX = screenSize.width - objectSize.width;
    final maxY = screenSize.height - objectSize.height;

    if (x <= 0) {
      x = 0;
      dx = dx.abs();
      bounced = true;
    } else if (x >= maxX) {
      x = maxX;
      dx = -dx.abs();
      bounced = true;
    }

    if (y <= 0) {
      y = 0;
      dy = dy.abs();
      bounced = true;
    } else if (y >= maxY) {
      y = maxY;
      dy = -dy.abs();
      bounced = true;
    }

    return current.copyWith(
      position: Offset(x, y),
      velocity: Offset(dx, dy),
      color: bounced ? _colorFactory() : current.color,
    );
  }
}
