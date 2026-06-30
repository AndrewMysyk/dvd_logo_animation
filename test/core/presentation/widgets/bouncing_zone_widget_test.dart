import 'package:dvd_logo_animation/core/presentation/animation/bouncing_coordinator.dart';
import 'package:dvd_logo_animation/core/presentation/widgets/bouncing_zone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoordinator extends Mock implements BouncingCoordinator<String> {}

void main() {
  setUpAll(() {
    registerFallbackValue(Size.zero);
    registerFallbackValue('');
  });

  group('BouncingZoneWidget', () {
    late _MockCoordinator mockCoordinator;

    setUp(() {
      mockCoordinator = _MockCoordinator();
      when(() => mockCoordinator.objectSize).thenReturn(const Size(100, 50));
      when(
        () => mockCoordinator.initial(screenSize: any(named: 'screenSize')),
      ).thenReturn('initial');
      when(
        () => mockCoordinator.tick(
          current: any(named: 'current'),
          screenSize: any(named: 'screenSize'),
        ),
      ).thenReturn('ticked');
    });

    Widget buildSubject() => MaterialApp(
      home: Scaffold(
        body: BouncingZoneWidget<String>(
          coordinator: mockCoordinator,
          builder: Text.new,
        ),
      ),
    );

    testWidgets('should render builder output with initial state from coordinator', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Assert
      expect(find.text('initial'), findsOneWidget);
    });

    testWidgets('should rebuild builder with updated state after each tick', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 16));

      // Assert
      expect(find.text('ticked'), findsOneWidget);
    });

    testWidgets('should restart animation when screen size changes', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCoordinator.initial(screenSize: const Size(200, 400)),
      ).thenReturn('restarted');

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('initial'), findsOneWidget);

      // Act — simulate resize by changing MediaQuery size
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(200, 400)),
          child: MaterialApp(
            home: Scaffold(
              body: BouncingZoneWidget<String>(
                coordinator: mockCoordinator,
                builder: Text.new,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('restarted'), findsOneWidget);
    });
  });
}
