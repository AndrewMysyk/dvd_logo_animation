import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdAnimationState', () {
    const logo = DvdLogoEntity(
      position: Offset(10, 20),
      velocity: Offset(1, -1),
      color: Colors.red,
    );
    const state = DvdAnimationState(logo: logo);

    group('initial', () {
      test('should have zero position and velocity', () {
        // Act
        final initial = DvdAnimationState.initial();
        // Assert
        expect(initial.logo.position, Offset.zero);
        expect(initial.logo.velocity, Offset.zero);
      });

      test('should have red as the initial color', () {
        // Act
        final initial = DvdAnimationState.initial();
        // Assert
        expect(initial.logo.color, Colors.red);
      });
    });

    group('copyWith', () {
      test('should return copy with updated logo', () {
        // Arrange
        const newLogo = DvdLogoEntity(
          position: Offset(50, 60),
          velocity: Offset(-1, 1),
          color: Colors.blue,
        );
        // Act
        final result = state.copyWith(logo: newLogo);
        // Assert
        expect(result.logo.position, newLogo.position);
        expect(result.logo.velocity, newLogo.velocity);
        expect(result.logo.color, newLogo.color);
      });

      test('should retain original logo when no argument provided', () {
        // Act
        final result = state.copyWith();
        // Assert
        expect(result.logo.position, logo.position);
        expect(result.logo.velocity, logo.velocity);
        expect(result.logo.color, logo.color);
      });
    });

    group('Equatable', () {
      test('should be equal when all logo values are the same', () {
        // Arrange
        const other = DvdAnimationState(logo: logo);
        // Assert
        expect(state, equals(other));
      });

      test('should not be equal when position differs', () {
        // Arrange
        final other = DvdAnimationState(
          logo: logo.copyWith(position: const Offset(99, 99)),
        );
        // Assert
        expect(state, isNot(equals(other)));
      });

      test('should not be equal when velocity differs', () {
        // Arrange
        final other = DvdAnimationState(
          logo: logo.copyWith(velocity: const Offset(5, 5)),
        );
        // Assert
        expect(state, isNot(equals(other)));
      });

      test('should not be equal when color differs', () {
        // Arrange
        final other = DvdAnimationState(
          logo: logo.copyWith(color: Colors.blue),
        );
        // Assert
        expect(state, isNot(equals(other)));
      });
    });
  });
}
