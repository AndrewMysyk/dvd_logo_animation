import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_config.dart';
import 'package:dvd_logo_animation/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final class DvdLogoWidget extends StatelessWidget {
  const DvdLogoWidget({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    Assets.icons.dvdLogo,
    width: DvdLogoConfig.width,
    height: DvdLogoConfig.height,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
