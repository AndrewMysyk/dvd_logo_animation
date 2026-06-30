import 'dart:ui';

import 'package:dvd_logo_animation/core/extensions/color_extension.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:injectable/injectable.dart';

typedef ColorFactory = Color Function();

@lazySingleton
class DvdAnimationCoordinator {
  DvdAnimationCoordinator({@ignoreParam ColorFactory? colorFactory})
      : _colorFactory = colorFactory ?? _randomColor;

  static Color _randomColor() => ColorX.random();

  final ColorFactory _colorFactory;

  static const double _speed = 1.0;

  DvdLogoEntity initialLogo({
    required Size screenSize,
    required Size logoSize,
  }) =>
      DvdLogoEntity(
        position: Offset(
          (screenSize.width - logoSize.width) / 2,
          (screenSize.height - logoSize.height) / 2,
        ),
        velocity: const Offset(_speed, -_speed),
        color: _colorFactory(),
      );

  DvdLogoEntity tick({
    required DvdLogoEntity current,
    required Size screenSize,
    required Size logoSize,
  }) {
    var dx = current.velocity.dx;
    var dy = current.velocity.dy;
    var x = current.position.dx + dx;
    var y = current.position.dy + dy;
    var bounced = false;

    if (x <= 0) {
      x = 0;
      dx = dx.abs();
      bounced = true;
    } else if (x >= screenSize.width - logoSize.width) {
      x = screenSize.width - logoSize.width;
      dx = -dx.abs();
      bounced = true;
    }

    if (y <= 0) {
      y = 0;
      dy = dy.abs();
      bounced = true;
    } else if (y >= screenSize.height - logoSize.height) {
      y = screenSize.height - logoSize.height;
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
