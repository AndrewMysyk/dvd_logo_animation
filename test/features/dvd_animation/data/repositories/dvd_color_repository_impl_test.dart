import 'package:dvd_logo_animation/features/dvd_animation/data/repositories/dvd_color_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdColorRepositoryImpl', () {
    late DvdColorRepositoryImpl repository;

    setUp(() {
      repository = DvdColorRepositoryImpl();
    });

    group('colorAt', () {
      test('should return red at index 0', () {
        // Arrange — index 0 corresponds to Colors.red
        // Act
        final color = repository.colorAt(0);
        // Assert
        expect(color, Colors.red);
      });

      test('should return blue at index 1', () {
        // Arrange — index 1 corresponds to Colors.blue
        // Act
        final color = repository.colorAt(1);
        // Assert
        expect(color, Colors.blue);
      });

      test('should wrap around when index equals list length', () {
        // Arrange — 7 colors in total, index 7 wraps back to 0 (red)
        // Act
        final color = repository.colorAt(7);
        // Assert
        expect(color, Colors.red);
      });

      test('should wrap around for any multiple of list length', () {
        // Arrange — index 14 = 7 * 2, wraps to 0 (red)
        // Act
        final color = repository.colorAt(14);
        // Assert
        expect(color, Colors.red);
      });

      test('should return same color as index 1 when index is 8', () {
        // Arrange — 8 % 7 = 1, should return blue
        // Act
        final color = repository.colorAt(8);
        // Assert
        expect(color, Colors.blue);
      });
    });
  });
}
