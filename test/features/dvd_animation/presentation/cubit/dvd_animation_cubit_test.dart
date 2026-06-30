import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_cubit.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdAnimationCubit', () {
    DvdAnimationCubit buildCubit() => DvdAnimationCubit();

    group('initial state', () {
      test('should have isPlaying false and playbackSpeed 1.0', () {
        final cubit = buildCubit();
        expect(cubit.state, const DvdAnimationState.initial());
        cubit.close();
      });
    });
  });
}
