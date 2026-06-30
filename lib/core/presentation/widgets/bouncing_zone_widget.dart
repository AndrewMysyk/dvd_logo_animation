import 'package:dvd_logo_animation/core/presentation/animation/bouncing_animation_controller.dart';
import 'package:dvd_logo_animation/core/presentation/animation/bouncing_coordinator.dart';
import 'package:flutter/material.dart';

class BouncingZoneWidget<T> extends StatefulWidget {
  const BouncingZoneWidget({
    required this.coordinator,
    required this.builder,
    super.key,
  });

  final BouncingCoordinator<T> coordinator;
  final Widget Function(T state) builder;

  @override
  State<BouncingZoneWidget<T>> createState() => _BouncingZoneWidgetState<T>();
}

class _BouncingZoneWidgetState<T> extends State<BouncingZoneWidget<T>> {
  late final BouncingAnimationController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = BouncingAnimationController<T>(
      coordinator: widget.coordinator,
    );
  }

  // didChangeDependencies fires on mount and on every MediaQuery change (resize,
  // rotation), so it handles both the initial start and screen-size updates.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.start(screenSize: MediaQuery.sizeOf(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final state = _controller.animationState;
      if (state == null) {
        return const SizedBox.expand();
      }
      return widget.builder(state);
    },
  );
}
