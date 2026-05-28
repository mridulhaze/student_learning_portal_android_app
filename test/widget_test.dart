import 'package:flutter_test/flutter_test.dart';
import 'package:nu_student_portal/main.dart';


void main() {
  testWidgets('NU Portal smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NUPortalApp());
    expect(find.byType(NUPortalApp), findsOneWidget);
  });
}