import 'package:dvd_logo_animation/features/dvd_animation/presentation/view/dvd_animation_page.dart';
import 'package:flutter/material.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DVD Logo Animation',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: const DvdAnimationPage(),
  );
}
