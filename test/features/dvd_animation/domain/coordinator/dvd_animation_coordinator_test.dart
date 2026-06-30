import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/coordinator/dvd_animation_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDvdColorRepository extends Mock implements DvdColorRepository {}

void main() {
  group('DvdAnimationCoordinator', () {
    late _MockDvdColorRepository mockColorRepository;
    late DvdAnimationCoordinator coordinator;

    setUp(() {
      mockColorRepository = _MockDvdColorRepository();
      coordinator = DvdAnimationCoordinator(mockColorRepository);
      when(() => mockColorRepository.colorAt(any())).thenReturn(Colors.red);
    });

    group('initialLogo', () {
      test('should center the logo on screen with initial velocity', () {
        // Arrange
        const screenSize = Size(400, 800);
        const logoSize = Size(160, 72);

        // Act
        final logo = coordinator.initialLogo(
          screenSize: screenSize,
          logoSize: logoSize,
          colorIndex: 0,
        );

        // Assert
        expect(logo.position, const Offset((400 - 160) / 2, (800 - 72) / 2));
        expect(logo.velocity, const Offset(1, -1));
      });

      test('should use color from repository at given color index', () {
        // Arrange
        when(() => mockColorRepository.colorAt(2)).thenReturn(Colors.green);

        // Act
        final logo = coordinator.initialLogo(
          screenSize: const Size(400, 800),
          logoSize: const Size(160, 72),
          colorIndex: 2,
        );

        // Assert
        expect(logo.color, Colors.green);
        verify(() => mockColorRepository.colorAt(2)).called(1);
      });
    });

    group('tick', () {
      // All scenarios use Screen(20,20)/Logo(2,2) for the no-bounce case and
      // small screens for wall bounces, giving integer positions.

      DvdLogoEntity makeLogo({
        required Offset position,
        required Offset velocity,
        Color color = Colors.red,
      }) =>
          DvdLogoEntity(position: position, velocity: velocity, color: color);

      test('should advance position by velocity when no wall is hit', () {
        // Arrange — Screen(20,20), Logo(2,2): center=(9,9), vel=(1,-1)
        final logo = makeLogo(
          position: const Offset(9, 9),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 20),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(10, 8));
        expect(result.logo.velocity, const Offset(1, -1));
        expect(result.logo.color, Colors.red);
        expect(result.colorIndex, 0);
      });

      test('should bounce off the right wall and reverse dx', () {
        // Arrange — Screen(4,20), Logo(2,2): center=(1,9), vel=(1,-1)
        // x=1+1=2 >= 4-2=2 → right bounce
        when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        final logo = makeLogo(
          position: const Offset(1, 9),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(4, 20),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(2, 8));
        expect(result.logo.velocity, const Offset(-1, -1));
        expect(result.logo.color, Colors.blue);
        expect(result.colorIndex, 1);
      });

      test('should bounce off the left wall and reverse dx', () {
        // Arrange — logo moving left, about to hit x=0
        when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        final logo = makeLogo(
          position: const Offset(0.5, 5),
          velocity: const Offset(-1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 20),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(0, 4));
        expect(result.logo.velocity, const Offset(1, -1));
        expect(result.logo.color, Colors.blue);
        expect(result.colorIndex, 1);
      });

      test('should bounce off the top wall and reverse dy', () {
        // Arrange — Screen(20,3), Logo(2,2): center=(9,0.5), vel=(1,-1)
        // y=0.5-1=-0.5 ≤ 0 → top bounce
        when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        final logo = makeLogo(
          position: const Offset(9, 0.5),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 3),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(10, 0));
        expect(result.logo.velocity, const Offset(1, 1));
        expect(result.logo.color, Colors.blue);
        expect(result.colorIndex, 1);
      });

      test('should bounce off the bottom wall and reverse dy', () {
        // Arrange — logo moving down, about to hit bottom (Screen(20,3), Logo(2,2))
        // y=0+1=1 >= 3-2=1 → bottom bounce
        when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        final logo = makeLogo(
          position: const Offset(5, 0),
          velocity: const Offset(1, 1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 3),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(6, 1));
        expect(result.logo.velocity, const Offset(1, -1));
        expect(result.logo.color, Colors.blue);
        expect(result.colorIndex, 1);
      });

      test('should increment color index only once on a corner bounce', () {
        // Arrange — Screen(4,4), Logo(2,2): center=(1,1), vel=(1,-1)
        // x=2 >= 4-2=2 (right) AND y=0 ≤ 0 (top) → both bounce, single increment
        when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        final logo = makeLogo(
          position: const Offset(1, 1),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(4, 4),
          logoSize: const Size(2, 2),
          colorIndex: 0,
        );

        // Assert
        expect(result.logo.position, const Offset(2, 0));
        expect(result.logo.velocity, const Offset(-1, 1));
        expect(result.logo.color, Colors.blue);
        expect(result.colorIndex, 1);
        verify(() => mockColorRepository.colorAt(1)).called(1);
        verifyNever(() => mockColorRepository.colorAt(2));
      });
    });
  });
}
