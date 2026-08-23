import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/constants/app_strings.dart';
import 'package:nutriai/main.dart';

void main() {
  testWidgets('NutriAI smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriAiApp());
    expect(find.text(AppStrings.splashTitle), findsOneWidget);

    // Allow splash timer to complete and transition
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text(AppStrings.onboarding1Title), findsOneWidget);
  });
}
