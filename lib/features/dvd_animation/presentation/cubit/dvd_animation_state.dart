import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Colors;

final class DvdAnimationState extends Equatable {
  const DvdAnimationState({required this.logo});

  factory DvdAnimationState.initial() => const DvdAnimationState(
    logo: DvdLogoEntity(
      position: Offset.zero,
      velocity: Offset.zero,
      color: Colors.red,
    ),
  );

  final DvdLogoEntity logo;

  DvdAnimationState copyWith({DvdLogoEntity? logo}) =>
      DvdAnimationState(logo: logo ?? this.logo);

  @override
  List<Object> get props => [
    logo.position.dx,
    logo.position.dy,
    logo.velocity.dx,
    logo.velocity.dy,
    logo.color,
  ];
}
