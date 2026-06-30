import 'dart:async';
import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/coordinator/dvd_animation_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

typedef TickerFactory = Stream<void> Function();

@injectable
final class DvdAnimationCubit extends Cubit<DvdAnimationState> {
  DvdAnimationCubit(
    this._coordinator, {
    @ignoreParam TickerFactory? tickerFactory,
  }) : _tickerFactory = tickerFactory ?? _defaultTicker,
       super(DvdAnimationState.initial());

  static Stream<void> _defaultTicker() =>
      Stream<void>.periodic(const Duration(milliseconds: 16));

  final DvdAnimationCoordinator _coordinator;
  final TickerFactory _tickerFactory;

  Size _screenSize = Size.zero;
  Size _logoSize = Size.zero;
  StreamSubscription<void>? _tickerSubscription;

  Future<void> start(Size screenSize, Size logoSize) async {
    _screenSize = screenSize;
    _logoSize = logoSize;
    await _tickerSubscription?.cancel();

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        logo: _coordinator.initialLogo(
          screenSize: screenSize,
          logoSize: logoSize,
        ),
      ),
    );

    _tickerSubscription = _tickerFactory().listen((_) => _tick());
  }

  void _tick() {
    final logo = _coordinator.tick(
      current: state.logo,
      screenSize: _screenSize,
      logoSize: _logoSize,
    );

    if (isClosed) {
      return;
    }

    emit(state.copyWith(logo: logo));
  }

  @override
  Future<void> close() async {
    await _tickerSubscription?.cancel();
    return super.close();
  }
}
