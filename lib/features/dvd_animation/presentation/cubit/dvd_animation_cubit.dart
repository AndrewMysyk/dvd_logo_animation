import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class DvdAnimationCubit extends Cubit<DvdAnimationState> {
  DvdAnimationCubit() : super(const DvdAnimationState.initial());

  void togglePlay() {}

  void playbackSpeedChanged(double speed) {}
}
