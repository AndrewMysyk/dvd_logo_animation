import 'package:equatable/equatable.dart';

final class DvdAnimationState extends Equatable {
  const DvdAnimationState({
    required this.isPlaying,
    required this.playbackSpeed,
  });

  const DvdAnimationState.initial()
      : isPlaying = false,
        playbackSpeed = 1.0;

  final bool isPlaying;
  final double playbackSpeed;

  DvdAnimationState copyWith({bool? isPlaying, double? playbackSpeed}) =>
      DvdAnimationState(
        isPlaying: isPlaying ?? this.isPlaying,
        playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      );

  @override
  List<Object> get props => [isPlaying, playbackSpeed];
}
