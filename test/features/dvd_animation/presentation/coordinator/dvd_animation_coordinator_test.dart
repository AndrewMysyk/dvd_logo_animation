import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/presentation/coordinator/dvd_animation_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_state.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdAnimationCoordinator', () {
    // objectSize: Size(2,2) keeps test math simple without affecting physics logic
    late DvdAnimationCoordinator coordinator;

    const fixedColor = Colors.blue;

    setUp(() {
      coordinator = DvdAnimationCoordinator(
        colorFactory: () => fixedColor,
        objectSize: const Size(2, 2),
      );
    });

    group('initial', () {
      test('should center the logo on screen with initial velocity', () {
        // Arrange
        const screenSize = Size(400, 800);

        // Act
        final logo = coordinator.initial(screenSize: screenSize);

        // Assert
        expect(logo.position, const Offset((400 - 2) / 2, (800 - 2) / 2));
        expect(logo.velocity, const Offset(1, -1));
      });

      test('should use color from the color factory', () {
        // Act
        final logo = coordinator.initial(screenSize: const Size(400, 800));

        // Assert
        expect(logo.color, fixedColor);
      });
    });

    group('tick', () {
      DvdLogoState makeLogo({
        required Offset position,
        required Offset velocity,
      }) => DvdLogoState(
        position: position,
        velocity: velocity,
        color: Colors.red,
      );

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
        );

        // Assert
        expect(result.position, const Offset(10, 8));
        expect(result.velocity, const Offset(1, -1));
        expect(result.color, Colors.red);
      });

      test('should bounce off the right wall and reverse dx', () {
        // Arrange — Screen(4,20), Logo(2,2): x=1+1=2 >= 4-2=2 → right bounce
        final logo = makeLogo(
          position: const Offset(1, 9),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(4, 20),
        );

        // Assert
        expect(result.position, const Offset(2, 8));
        expect(result.velocity, const Offset(-1, -1));
        expect(result.color, fixedColor);
      });

      test('should bounce off the left wall and reverse dx', () {
        // Arrange — x=0.5-1=-0.5 ≤ 0 → left bounce
        final logo = makeLogo(
          position: const Offset(0.5, 5),
          velocity: const Offset(-1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 20),
        );

        // Assert
        expect(result.position, const Offset(0, 4));
        expect(result.velocity, const Offset(1, -1));
        expect(result.color, fixedColor);
      });

      test('should bounce off the top wall and reverse dy', () {
        // Arrange — Screen(20,3), Logo(2,2): y=0.5-1=-0.5 ≤ 0 → top bounce
        final logo = makeLogo(
          position: const Offset(9, 0.5),
          velocity: const Offset(1, -1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 3),
        );

        // Assert
        expect(result.position, const Offset(10, 0));
        expect(result.velocity, const Offset(1, 1));
        expect(result.color, fixedColor);
      });

      test('should bounce off the bottom wall and reverse dy', () {
        // Arrange — Screen(20,3), Logo(2,2): y=0+1=1 >= 3-2=1 → bottom bounce
        final logo = makeLogo(
          position: const Offset(5, 0),
          velocity: const Offset(1, 1),
        );

        // Act
        final result = coordinator.tick(
          current: logo,
          screenSize: const Size(20, 3),
        );

        // Assert
        expect(result.position, const Offset(6, 1));
        expect(result.velocity, const Offset(1, -1));
        expect(result.color, fixedColor);
      });

      test('should call color factory only once on a corner bounce', () {
        // Arrange — Screen(4,4), Logo(2,2): right AND top bounce in same tick
        var callCount = 0;
        final countingCoordinator = DvdAnimationCoordinator(
          colorFactory: () {
            callCount++;
            return fixedColor;
          },
          objectSize: const Size(2, 2),
        );
        final logo = makeLogo(
          position: const Offset(1, 1),
          velocity: const Offset(1, -1),
        );

        // Act
        countingCoordinator.tick(current: logo, screenSize: const Size(4, 4));

        // Assert
        expect(callCount, 1);
      });
    });
  });
}
