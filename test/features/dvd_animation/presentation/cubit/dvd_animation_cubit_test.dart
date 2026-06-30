import 'dart:async';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/coordinator/dvd_animation_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_cubit.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDvdAnimationCoordinator extends Mock
    implements DvdAnimationCoordinator {}

void main() {
  setUpAll(() {
    registerFallbackValue(Size.zero);
    registerFallbackValue(
      const DvdLogoEntity(
        position: Offset.zero,
        velocity: Offset.zero,
        color: Colors.red,
      ),
    );
  });

  group('DvdAnimationCubit', () {
    late _MockDvdAnimationCoordinator mockCoordinator;
    late StreamController<void> tickController;

    const screenSize = Size(400, 800);
    const logoSize = Size(160, 72);

    const initialLogo = DvdLogoEntity(
      position: Offset(120, 364),
      velocity: Offset(1, -1),
      color: Colors.red,
    );

    const tickedLogo = DvdLogoEntity(
      position: Offset(121, 363),
      velocity: Offset(1, -1),
      color: Colors.red,
    );

    const recenteredLogo = DvdLogoEntity(
      position: Offset(20, 164),
      velocity: Offset(1, -1),
      color: Colors.blue,
    );

    setUp(() {
      mockCoordinator = _MockDvdAnimationCoordinator();
      tickController = StreamController<void>.broadcast(sync: true);

      when(
        () => mockCoordinator.initialLogo(
          screenSize: any(named: 'screenSize'),
          logoSize: any(named: 'logoSize'),
        ),
      ).thenReturn(initialLogo);

      when(
        () => mockCoordinator.tick(
          current: any(named: 'current'),
          screenSize: any(named: 'screenSize'),
          logoSize: any(named: 'logoSize'),
        ),
      ).thenReturn(tickedLogo);
    });

    tearDown(() async {
      await tickController.close();
    });

    DvdAnimationCubit buildCubit() => DvdAnimationCubit(
          mockCoordinator,
          tickerFactory: () => tickController.stream,
        );

    group('start', () {
      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should emit logo from coordinator',
        build: buildCubit,
        act: (cubit) => cubit.start(screenSize, logoSize),
        wait: Duration.zero,
        verify: (_) => verify(
          () => mockCoordinator.initialLogo(
            screenSize: screenSize,
            logoSize: logoSize,
          ),
        ).called(1),
        expect: () => [const DvdAnimationState(logo: initialLogo)],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should re-emit when called with a new screen size',
        build: buildCubit,
        setUp: () {
          when(
            () => mockCoordinator.initialLogo(
              screenSize: const Size(200, 400),
              logoSize: any(named: 'logoSize'),
            ),
          ).thenReturn(recenteredLogo);
        },
        act: (cubit) async {
          await cubit.start(screenSize, logoSize);
          await cubit.start(const Size(200, 400), logoSize);
        },
        wait: Duration.zero,
        skip: 1,
        verify: (_) => verify(
          () => mockCoordinator.initialLogo(
            screenSize: const Size(200, 400),
            logoSize: logoSize,
          ),
        ).called(1),
        expect: () => [const DvdAnimationState(logo: recenteredLogo)],
      );
    });

    group('tick', () {
      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should delegate to coordinator and emit result on each tick',
        build: buildCubit,
        act: (cubit) async {
          await cubit.start(screenSize, logoSize);
          tickController.add(null);
        },
        skip: 1,
        verify: (_) => verify(
          () => mockCoordinator.tick(
            current: initialLogo,
            screenSize: screenSize,
            logoSize: logoSize,
          ),
        ).called(1),
        expect: () => [const DvdAnimationState(logo: tickedLogo)],
      );
    });

    group('close', () {
      test('should cancel ticker subscription on close', () async {
        final cubit = buildCubit();

        await cubit.start(screenSize, logoSize);
        expect(tickController.hasListener, isTrue);

        await cubit.close();
        expect(tickController.hasListener, isFalse);
      });
    });
  });
}
