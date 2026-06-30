import 'package:dvd_logo_animation/core/presentation/widgets/bouncing_zone_widget.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/dvd_logo_state.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/view/dvd_animation_page.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/widgets/dvd_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdAnimationPage', () {
    testWidgets('should render Scaffold with black background', (tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: DvdAnimationPage()));

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });

    testWidgets('should render BouncingZoneWidget', (tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: DvdAnimationPage()));

      // Assert
      expect(find.byType(BouncingZoneWidget<DvdLogoState>), findsOneWidget);
    });

    testWidgets('should render DvdLogoWidget once animation starts', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: DvdAnimationPage()));
      await tester.pump();

      // Assert
      expect(find.byType(DvdLogoWidget), findsOneWidget);
    });
  });
}
