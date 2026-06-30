import 'package:dvd_logo_animation/app.dart';
import 'package:dvd_logo_animation/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(configureDependencies);
  tearDownAll(GetIt.instance.reset);

  group('App', () {
    testWidgets('should render without error', (tester) async {
      // Act
      await tester.pumpWidget(const App());
      // Assert
      expect(find.byType(App), findsOneWidget);
    });
  });
}
