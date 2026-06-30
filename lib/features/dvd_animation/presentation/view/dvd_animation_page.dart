import 'package:dvd_logo_animation/core/di/service_locator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_config.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_cubit.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_state.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/widgets/dvd_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DvdAnimationPage extends StatelessWidget {
  const DvdAnimationPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => locator.get<DvdAnimationCubit>(),
    child: const _DvdAnimationView(),
  );
}

class _DvdAnimationView extends StatefulWidget {
  const _DvdAnimationView();

  @override
  State<_DvdAnimationView> createState() => _DvdAnimationViewState();
}

class _DvdAnimationViewState extends State<_DvdAnimationView> {
  Size? _lastScreenSize;

  void _maybeStart(Size screenSize) {
    if (screenSize == _lastScreenSize) {
      return;
    }
    _lastScreenSize = screenSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<DvdAnimationCubit>().start(
        screenSize,
        const Size(DvdLogoConfig.width, DvdLogoConfig.height),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: LayoutBuilder(
      builder: (_, constraints) {
        _maybeStart(constraints.biggest);
        return BlocBuilder<DvdAnimationCubit, DvdAnimationState>(
          builder: (context, state) => Stack(
            children: [
              Positioned(
                left: state.logo.position.dx,
                top: state.logo.position.dy,
                child: DvdLogoWidget(color: state.logo.color),
              ),
            ],
          ),
        );
      },
    ),
  );
}
