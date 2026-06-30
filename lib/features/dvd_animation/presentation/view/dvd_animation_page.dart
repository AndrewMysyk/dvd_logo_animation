import 'package:dvd_logo_animation/core/presentation/widgets/bouncing_zone_widget.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/coordinator/dvd_animation_coordinator.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_state.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/widgets/dvd_logo_widget.dart';
import 'package:flutter/material.dart';

class DvdAnimationPage extends StatelessWidget {
  const DvdAnimationPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: BouncingZoneWidget<DvdLogoState>(
      coordinator: DvdAnimationCoordinator(),
      builder: (animation) => Stack(
        children: [
          Positioned(
            left: animation.position.dx,
            top: animation.position.dy,
            child: DvdLogoWidget(color: animation.color),
          ),
        ],
      ),
    ),
  );
}
