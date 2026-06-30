import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdLogoEntity', () {
    const entity = DvdLogoEntity(
      position: Offset(10, 20),
      velocity: Offset(1, -1),
      color: Colors.red,
    );

    group('copyWith', () {
      test('should return copy with updated position', () {
        // Arrange
        const newPosition = Offset(99, 88);
        // Act
        final result = entity.copyWith(position: newPosition);
        // Assert
        expect(result.position, newPosition);
        expect(result.velocity, entity.velocity);
        expect(result.color, entity.color);
      });

      test('should return copy with updated velocity', () {
        // Arrange
        const newVelocity = Offset(-1, 1);
        // Act
        final result = entity.copyWith(velocity: newVelocity);
        // Assert
        expect(result.velocity, newVelocity);
        expect(result.position, entity.position);
        expect(result.color, entity.color);
      });

      test('should return copy with updated color', () {
        // Arrange
        const newColor = Colors.blue;
        // Act
        final result = entity.copyWith(color: newColor);
        // Assert
        expect(result.color, newColor);
        expect(result.position, entity.position);
        expect(result.velocity, entity.velocity);
      });

      test('should retain all original values when no arguments provided', () {
        // Act
        final result = entity.copyWith();
        // Assert
        expect(result.position, entity.position);
        expect(result.velocity, entity.velocity);
        expect(result.color, entity.color);
      });
    });
  });
}
