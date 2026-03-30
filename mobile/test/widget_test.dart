import 'package:flutter_test/flutter_test.dart';

import 'package:ethiopia_autism_support_app/app.dart';

void main() {
  testWidgets('shows key home sections', (tester) async {
    await tester.pumpWidget(const AutismSupportApp());

    expect(find.text('Ethiopia Autism Support'), findsWidgets);
    expect(find.text('Child Learning'), findsOneWidget);
    expect(find.text('Parent Community'), findsOneWidget);
    expect(find.text('AI Parent Assistant'), findsOneWidget);
  });
}
