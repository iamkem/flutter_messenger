import 'package:flutter_test/flutter_test.dart';
import 'package:messio_app/main.dart';
import 'package:messio_app/pages/ConversationPageList.dart';

void main() {
  testWidgets('Main UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.byType(ConversationPageList),findsOneWidget);
  }); 
}
