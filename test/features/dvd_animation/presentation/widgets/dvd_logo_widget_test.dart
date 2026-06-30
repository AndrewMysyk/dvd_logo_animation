import 'package:dvd_logo_animation/features/dvd_animation/domain/entities/dvd_logo_config.dart';
import 'package:dvd_logo_animation/features/dvd_animation/presentation/widgets/dvd_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DvdLogoWidget', () {
    testWidgets('should render SvgPicture with the given color filter', (
      tester,
    ) async {
      // Arrange
      const color = Colors.red;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DvdLogoWidget(color: color)),
        ),
      );

      // Assert
      expect(find.byType(DvdLogoWidget), findsOneWidget);
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(
        svg.colorFilter,
        const ColorFilter.mode(color, BlendMode.srcIn),
      );
    });

    testWidgets('should render with correct dimensions', (tester) async {
      // Arrange
      const color = Colors.blue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DvdLogoWidget(color: color)),
        ),
      );
      await tester.pump();

      // Assert
      final renderBox = tester.renderObject<RenderBox>(
        find.byType(DvdLogoWidget),
      );
      expect(renderBox.size.width, moreOrLessEquals(DvdLogoConfig.width, epsilon: 1));
      expect(renderBox.size.height, moreOrLessEquals(DvdLogoConfig.height, epsilon: 1));
    });
  });
}
