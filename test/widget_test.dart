import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:thesaurus_omicron/plugins/plugin_manager.dart';

import 'package:thesaurus_omicron/thesaurus_app.dart';

class _PluginManagerMock extends Mock implements PluginManager {}

void main() {
  testWidgets('By default, an empty ListView is present in the container', (WidgetTester tester) async {
    final pluginManager = _PluginManagerMock();

    await tester.pumpWidget(ThesaurusApp(pluginManager));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.descendant(of: find.byType(ListView), matching: find.byType(Card)), findsNothing);
  });
}
