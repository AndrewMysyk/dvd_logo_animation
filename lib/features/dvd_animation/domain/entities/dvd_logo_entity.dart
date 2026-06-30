import 'dart:ui';

final class DvdLogoEntity {
  const DvdLogoEntity({
    required this.position,
    required this.velocity,
    required this.color,
  });

  final Offset position;
  final Offset velocity;
  final Color color;

  DvdLogoEntity copyWith({Offset? position, Offset? velocity, Color? color}) =>
      DvdLogoEntity(
        position: position ?? this.position,
        velocity: velocity ?? this.velocity,
        color: color ?? this.color,
      );
}
