import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DvdAnimationCoordinator {
  const DvdAnimationCoordinator(this._colorRepository);

  final DvdColorRepository _colorRepository;

  static const double _speed = 1.0;

  DvdLogoEntity initialLogo({
    required Size screenSize,
    required Size logoSize,
    required int colorIndex,
  }) =>
      DvdLogoEntity(
        position: Offset(
          (screenSize.width - logoSize.width) / 2,
          (screenSize.height - logoSize.height) / 2,
        ),
        velocity: const Offset(_speed, -_speed),
        color: _colorRepository.colorAt(colorIndex),
      );

  ({DvdLogoEntity logo, int colorIndex}) tick({
    required DvdLogoEntity current,
    required Size screenSize,
    required Size logoSize,
    required int colorIndex,
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

    final newColorIndex = bounced ? colorIndex + 1 : colorIndex;

    return (
      logo: current.copyWith(
        position: Offset(x, y),
        velocity: Offset(dx, dy),
        color: bounced ? _colorRepository.colorAt(newColorIndex) : current.color,
      ),
      colorIndex: newColorIndex,
    );
  }
}
