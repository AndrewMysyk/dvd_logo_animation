import 'dart:async';
import 'dart:ui';

import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_entity.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

typedef TickerFactory = Stream<void> Function();

@injectable
final class DvdAnimationCubit extends Cubit<DvdAnimationState> {
  DvdAnimationCubit(this._colorRepository, {TickerFactory? tickerFactory})
      : _tickerFactory = tickerFactory ?? _defaultTicker,
        super(DvdAnimationState.initial());

  static Stream<void> _defaultTicker() =>
      Stream<void>.periodic(const Duration(milliseconds: 16));

  final DvdColorRepository _colorRepository;
  final TickerFactory _tickerFactory;

  static const double _speed = 1;

  Size _screenSize = Size.zero;
  Size _logoSize = Size.zero;
  StreamSubscription<void>? _tickerSubscription;
  int _colorIndex = 0;

  Future<void> start(Size screenSize, Size logoSize) async {
    _screenSize = screenSize;
    _logoSize = logoSize;
    _colorIndex = 0;
    await _tickerSubscription?.cancel();

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        logo: DvdLogoEntity(
          position: Offset(
            (_screenSize.width - _logoSize.width) / 2,
            (_screenSize.height - _logoSize.height) / 2,
          ),
          velocity: const Offset(_speed, -_speed),
          color: _colorRepository.colorAt(_colorIndex),
        ),
      ),
    );

    _tickerSubscription = _tickerFactory().listen((_) => _tick());
  }

  void _tick() {
    final logo = state.logo;
    var dx = logo.velocity.dx;
    var dy = logo.velocity.dy;
    var x = logo.position.dx + dx;
    var y = logo.position.dy + dy;
    var bounced = false;

    if (x <= 0) {
      x = 0;
      dx = dx.abs();
      bounced = true;
    } else if (x >= _screenSize.width - _logoSize.width) {
      x = _screenSize.width - _logoSize.width;
      dx = -dx.abs();
      bounced = true;
    }

    if (y <= 0) {
      y = 0;
      dy = dy.abs();
      bounced = true;
    } else if (y >= _screenSize.height - _logoSize.height) {
      y = _screenSize.height - _logoSize.height;
      dy = -dy.abs();
      bounced = true;
    }

    if (bounced) {
      _colorIndex++;
    }

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        logo: logo.copyWith(
          position: Offset(x, y),
          velocity: Offset(dx, dy),
          color: bounced ? _colorRepository.colorAt(_colorIndex) : logo.color,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _tickerSubscription?.cancel();
    return super.close();
  }
}
