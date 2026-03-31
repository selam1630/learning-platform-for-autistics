import 'package:ethiopia_autism_support_app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows onboarding welcome screen on first launch', (tester) async {
    await tester.pumpWidget(const AutismSupportApp());

    expect(find.text('Helping your child learn and grow'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
