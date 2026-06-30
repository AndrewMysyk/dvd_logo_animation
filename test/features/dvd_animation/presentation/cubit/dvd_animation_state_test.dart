import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdAnimationState', () {
    group('initial', () {
      test('should have isPlaying false', () {
        const state = DvdAnimationState.initial();
        expect(state.isPlaying, false);
      });

      test('should have playbackSpeed of 1.0', () {
        const state = DvdAnimationState.initial();
        expect(state.playbackSpeed, 1.0);
      });
    });

    group('copyWith', () {
      const state = DvdAnimationState(isPlaying: false, playbackSpeed: 1.0);

      test('should return copy with updated isPlaying', () {
        final result = state.copyWith(isPlaying: true);
        expect(result.isPlaying, true);
        expect(result.playbackSpeed, state.playbackSpeed);
      });

      test('should return copy with updated playbackSpeed', () {
        final result = state.copyWith(playbackSpeed: 2.0);
        expect(result.playbackSpeed, 2.0);
        expect(result.isPlaying, state.isPlaying);
      });

      test('should retain original values when no arguments provided', () {
        final result = state.copyWith();
        expect(result.isPlaying, state.isPlaying);
        expect(result.playbackSpeed, state.playbackSpeed);
      });
    });

    group('Equatable', () {
      const state = DvdAnimationState(isPlaying: true, playbackSpeed: 1.5);

      test('should be equal when all values are the same', () {
        const other = DvdAnimationState(isPlaying: true, playbackSpeed: 1.5);
        expect(state, equals(other));
      });

      test('should not be equal when isPlaying differs', () {
        const other = DvdAnimationState(isPlaying: false, playbackSpeed: 1.5);
        expect(state, isNot(equals(other)));
      });

      test('should not be equal when playbackSpeed differs', () {
        const other = DvdAnimationState(isPlaying: true, playbackSpeed: 2.0);
        expect(state, isNot(equals(other)));
      });
    });
  });
}
