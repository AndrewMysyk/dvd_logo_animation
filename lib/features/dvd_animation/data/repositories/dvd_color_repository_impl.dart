import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:injectable/injectable.dart';

@LazySingleton(as: DvdColorRepository)
final class DvdColorRepositoryImpl implements DvdColorRepository {
  static const List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.white,
  ];

  @override
  Color colorAt(final int index) => _colors[index % _colors.length];
}
