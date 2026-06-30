import 'dart:async';
import 'dart:ui';

import 'package:dvd_logo_animation/core/presentation/animation/bouncing_animation_controller.dart';
import 'package:dvd_logo_animation/core/presentation/animation/bouncing_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_state.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBouncingCoordinator extends Mock
    implements BouncingCoordinator<DvdLogoState> {}

void main() {
  setUpAll(() {
    registerFallbackValue(Size.zero);
    registerFallbackValue(
      const DvdLogoState(
        position: Offset.zero,
        velocity: Offset.zero,
        color: Colors.red,
      ),
    );
  });

  group('BouncingAnimationController', () {
    late _MockBouncingCoordinator mockCoordinator;
    late StreamController<void> tickController;

    const screenSize = Size(400, 800);

    const initialState = DvdLogoState(
      position: Offset(120, 364),
      velocity: Offset(1, -1),
      color: Colors.red,
    );

    const tickedState = DvdLogoState(
      position: Offset(121, 363),
      velocity: Offset(1, -1),
      color: Colors.red,
    );

    setUp(() {
      mockCoordinator = _MockBouncingCoordinator();
      tickController = StreamController<void>.broadcast(sync: true);

      when(() => mockCoordinator.objectSize).thenReturn(const Size(160, 72));

      when(
        () => mockCoordinator.initial(screenSize: any(named: 'screenSize')),
      ).thenReturn(initialState);

      when(
        () => mockCoordinator.tick(
          current: any(named: 'current'),
          screenSize: any(named: 'screenSize'),
        ),
      ).thenReturn(tickedState);
    });

    tearDown(() async {
      await tickController.close();
    });

    BouncingAnimationController<DvdLogoState> buildController() =>
        BouncingAnimationController<DvdLogoState>(
          coordinator: mockCoordinator,
          tickerFactory: () => tickController.stream,
        );

    group('animationState', () {
      test('should be null before start is called', () {
        // Arrange
        final controller = buildController();

        // Assert
        expect(controller.animationState, isNull);

        controller.dispose();
      });
    });

    group('start', () {
      test('should set animationState from coordinator', () {
        // Arrange
        final controller = buildController();

        // Act
        controller.start(screenSize: screenSize);

        // Assert
        expect(controller.animationState, initialState);

        controller.dispose();
      });

      test('should notify listeners when animationState is set', () {
        // Arrange
        final controller = buildController();
        var notifyCount = 0;
        controller.addListener(() => notifyCount++);

        // Act
        controller.start(screenSize: screenSize);

        // Assert
        expect(notifyCount, 1);

        controller.dispose();
      });

      test(
        'should restart animation when called again with a new screen size',
        () {
          // Arrange
          const newScreenSize = Size(200, 400);
          const recenteredState = DvdLogoState(
            position: Offset(20, 164),
            velocity: Offset(1, -1),
            color: Colors.blue,
          );
          when(
            () => mockCoordinator.initial(screenSize: newScreenSize),
          ).thenReturn(recenteredState);

          final controller = buildController();
          controller.start(screenSize: screenSize);

          // Act
          controller.start(screenSize: newScreenSize);

          // Assert
          expect(controller.animationState, recenteredState);

          controller.dispose();
        },
      );
    });

    group('tick', () {
      test('should update animationState via coordinator on each tick', () {
        // Arrange
        final controller = buildController();
        controller.start(screenSize: screenSize);

        // Act
        tickController.add(null);

        // Assert
        expect(controller.animationState, tickedState);
        verify(
          () => mockCoordinator.tick(
            current: initialState,
            screenSize: screenSize,
          ),
        ).called(1);

        controller.dispose();
      });

      test('should notify listeners on each tick', () {
        // Arrange
        final controller = buildController();
        controller.start(screenSize: screenSize);
        var notifyCount = 0;
        controller.addListener(() => notifyCount++);

        // Act
        tickController.add(null);
        tickController.add(null);

        // Assert
        expect(notifyCount, 2);

        controller.dispose();
      });
    });

    group('dispose', () {
      test('should cancel ticker subscription on dispose', () {
        // Arrange
        final controller = buildController();
        controller.start(screenSize: screenSize);
        expect(tickController.hasListener, isTrue);

        // Act
        controller.dispose();

        // Assert
        expect(tickController.hasListener, isFalse);
      });
    });
  });
}
