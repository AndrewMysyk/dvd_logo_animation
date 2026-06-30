import 'dart:ui';

final class DvdLogoState {
  const DvdLogoState({
    required this.position,
    required this.velocity,
    required this.color,
  });

  final Offset position;
  final Offset velocity;
  final Color color;

  DvdLogoState copyWith({Offset? position, Offset? velocity, Color? color}) =>
      DvdLogoState(
        position: position ?? this.position,
        velocity: velocity ?? this.velocity,
        color: color ?? this.color,
      );
}
