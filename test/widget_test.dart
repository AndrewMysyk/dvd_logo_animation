import 'package:dvd_logo_animation/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DVD animation app renders without error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
