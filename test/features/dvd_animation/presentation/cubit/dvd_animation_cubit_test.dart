import 'dart:async';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_cubit.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDvdColorRepository extends Mock implements DvdColorRepository {}

void main() {
  group('DvdAnimationCubit', () {
    late _MockDvdColorRepository mockColorRepository;
    late StreamController<void> tickController;

    const screenSize = Size(400, 800);
    const logoSize = Size(160, 72);

    setUp(() {
      mockColorRepository = _MockDvdColorRepository();
      // sync: true delivers events to listeners synchronously so tick tests
      // are deterministic without needing delays.
      tickController = StreamController<void>.broadcast(sync: true);
      when(() => mockColorRepository.colorAt(any())).thenReturn(Colors.red);
    });

    tearDown(() async {
      await tickController.close();
    });

    DvdAnimationCubit buildCubit() => DvdAnimationCubit(
          mockColorRepository,
          tickerFactory: () => tickController.stream,
        );

    group('start', () {
      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should emit logo centered on screen with initial velocity',
        build: buildCubit,
        act: (cubit) => cubit.start(screenSize, logoSize),
        wait: Duration.zero,
        expect: () => [
          const DvdAnimationState(
            logo: DvdLogoEntity(
              position: Offset(
                (400 - 160) / 2,
                (800 - 72) / 2,
              ),
              velocity: Offset(1, -1),
              color: Colors.red,
            ),
          ),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should use color from repository at index 0 on start',
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.green);
        },
        act: (cubit) => cubit.start(screenSize, logoSize),
        wait: Duration.zero,
        verify: (_) => verify(() => mockColorRepository.colorAt(0)).called(1),
        expect: () => [
          isA<DvdAnimationState>().having(
            (s) => s.logo.color,
            'color',
            Colors.green,
          ),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should re-center logo when called with a new screen size',
        build: buildCubit,
        act: (cubit) async {
          await cubit.start(screenSize, logoSize);
          await cubit.start(const Size(200, 400), logoSize);
        },
        wait: Duration.zero,
        skip: 1,
        expect: () => [
          const DvdAnimationState(
            logo: DvdLogoEntity(
              position: Offset(
                (200 - 160) / 2,
                (400 - 72) / 2,
              ),
              velocity: Offset(1, -1),
              color: Colors.red,
            ),
          ),
        ],
      );
    });

    group('tick', () {
      // All scenarios use Screen(4,20) / Logo(2,2) for x-axis tests and
      // Screen(20,3) / Logo(2,2) for y-axis tests, giving integer start
      // positions so expected offsets stay exact.

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should advance position by velocity when no wall is hit',
        // Screen(20,20), Logo(2,2): center=(9,9), vel=(1,-1)
        // Tick 1: x=10, y=8 — all within bounds
        build: buildCubit,
        act: (cubit) async {
          await cubit.start(const Size(20, 20), const Size(2, 2));
          tickController.add(null);
        },
        skip: 1,
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(10, 8))
              .having((s) => s.logo.velocity, 'velocity', const Offset(1, -1))
              .having((s) => s.logo.color, 'color', Colors.red),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should bounce off the right wall and reverse dx',
        // Screen(4,20), Logo(2,2): center=(1,9), vel=(1,-1)
        // Tick 1: x=2 >= 4-2=2 → right bounce: x=2, dx=-1
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.red);
          when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        },
        act: (cubit) async {
          await cubit.start(const Size(4, 20), const Size(2, 2));
          tickController.add(null);
        },
        skip: 1,
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(2, 8))
              .having((s) => s.logo.velocity, 'velocity', const Offset(-1, -1))
              .having((s) => s.logo.color, 'color', Colors.blue),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should bounce off the left wall and reverse dx',
        // Screen(4,20), Logo(2,2): center=(1,9)
        // Tick 1: right bounce → (2,8), vel=(-1,-1)
        // Tick 2: no bounce → (1,7)
        // Tick 3: x=0 ≤ 0 → left bounce: x=0, dx=1
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.red);
          when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
          when(() => mockColorRepository.colorAt(2)).thenReturn(Colors.green);
        },
        act: (cubit) async {
          await cubit.start(const Size(4, 20), const Size(2, 2));
          tickController.add(null); // right bounce
          tickController.add(null); // no bounce
          tickController.add(null); // left bounce
        },
        skip: 3,
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(0, 6))
              .having((s) => s.logo.velocity, 'velocity', const Offset(1, -1))
              .having((s) => s.logo.color, 'color', Colors.green),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should bounce off the top wall and reverse dy',
        // Screen(20,3), Logo(2,2): center=(9,0.5), vel=(1,-1)
        // Tick 1: y=0.5-1=-0.5 ≤ 0 → top bounce: y=0, dy=1
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.red);
          when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        },
        act: (cubit) async {
          await cubit.start(const Size(20, 3), const Size(2, 2));
          tickController.add(null);
        },
        skip: 1,
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(10, 0))
              .having((s) => s.logo.velocity, 'velocity', const Offset(1, 1))
              .having((s) => s.logo.color, 'color', Colors.blue),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should bounce off the bottom wall and reverse dy',
        // Screen(20,3), Logo(2,2): center=(9,0.5), vel=(1,-1)
        // Tick 1: top bounce → (10,0), vel=(1,1)
        // Tick 2: y=0+1=1 >= 3-2=1 → bottom bounce: y=1, dy=-1
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.red);
          when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
          when(() => mockColorRepository.colorAt(2)).thenReturn(Colors.green);
        },
        act: (cubit) async {
          await cubit.start(const Size(20, 3), const Size(2, 2));
          tickController.add(null); // top bounce
          tickController.add(null); // bottom bounce
        },
        skip: 2,
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(11, 1))
              .having((s) => s.logo.velocity, 'velocity', const Offset(1, -1))
              .having((s) => s.logo.color, 'color', Colors.green),
        ],
      );

      blocTest<DvdAnimationCubit, DvdAnimationState>(
        'should increment color index only once on a corner bounce',
        // Screen(4,4), Logo(2,2): center=(1,1), vel=(1,-1)
        // Tick 1: x=2 >= 4-2=2 (right) AND y=0 ≤ 0 (top) → both bounce,
        //         but the single `bounced` flag means colorIndex++ runs once.
        build: buildCubit,
        setUp: () {
          when(() => mockColorRepository.colorAt(0)).thenReturn(Colors.red);
          when(() => mockColorRepository.colorAt(1)).thenReturn(Colors.blue);
        },
        act: (cubit) async {
          await cubit.start(const Size(4, 4), const Size(2, 2));
          tickController.add(null);
        },
        skip: 1,
        verify: (_) {
          verify(() => mockColorRepository.colorAt(1)).called(1);
          verifyNever(() => mockColorRepository.colorAt(2));
        },
        expect: () => [
          isA<DvdAnimationState>()
              .having((s) => s.logo.position, 'position', const Offset(2, 0))
              .having((s) => s.logo.velocity, 'velocity', const Offset(-1, 1))
              .having((s) => s.logo.color, 'color', Colors.blue),
        ],
      );
    });

    group('close', () {
      test('should cancel ticker subscription on close', () async {
        final cubit = buildCubit();

        await cubit.start(const Size(20, 20), const Size(2, 2));
        expect(tickController.hasListener, isTrue);

        await cubit.close();
        expect(tickController.hasListener, isFalse);
      });
    });
  });
}
