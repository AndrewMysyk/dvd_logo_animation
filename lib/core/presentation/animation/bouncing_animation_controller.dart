import 'dart:async';
import 'dart:ui';

import 'package:dvd_logo_animation/core/presentation/animation/bouncing_coordinator.dart';
import 'package:flutter/foundation.dart';

typedef TickerFactory = Stream<void> Function();

class BouncingAnimationController<T> extends ChangeNotifier {
  BouncingAnimationController({
    required this.coordinator,
    TickerFactory? tickerFactory,
  }) : _tickerFactory = tickerFactory ?? _defaultTicker;

  // 16 ms ≈ 60 fps, matching the standard display refresh rate
  static Stream<void> _defaultTicker() =>
      Stream<void>.periodic(const Duration(milliseconds: 16));

  final BouncingCoordinator<T> coordinator;
  final TickerFactory _tickerFactory;

  T? _animationState;
  T? get animationState => _animationState;

  Size _screenSize = Size.zero;
  StreamSubscription<void>? _subscription;

  void start({required Size screenSize}) {
    _screenSize = screenSize;
    _subscription?.cancel();
    _animationState = coordinator.initial(screenSize: screenSize);
    notifyListeners();
    _subscription = _tickerFactory().listen((_) => _tick());
  }

  void _tick() {
    if (_animationState == null) {
      return;
    }
    _animationState = coordinator.tick(
      current: _animationState as T,
      screenSize: _screenSize,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
