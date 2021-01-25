import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/plugin_manager.dart';
import 'package:thesaurus_omicron/plugins/plugin_post.dart';
import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/thesaurus_app.dart';

class _PluginManagerMock extends Mock implements PluginManager {}

class _PluginMock extends Mock implements Plugin {}

void main() {

  group("Home Widget", () {

    _PluginManagerMock pluginManager;
    
    ThesaurusApp app;

    Plugin gatewayPlugin;
    
    setUp(() {
      pluginManager = _PluginManagerMock();
      app = ThesaurusApp(pluginManager);
      gatewayPlugin = _PluginMock();
    });

    testWidgets('By default, an empty ListView is present in the container', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      expect(find.byType(ListView), findsOneWidget);
      expect(find.descendant(of: find.byType(ListView), matching: find.byType(Card)), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);

      verifyZeroInteractions(pluginManager);
      verifyZeroInteractions(gatewayPlugin);
    });

    testWidgets('Swiping down starts loading and displays a circular progress indicator', (WidgetTester tester) async {
      final StreamController controller = StreamController<PolledPosts>();

      await tester.pumpWidget(app);

      when(pluginManager.getGatewayPlugin()).thenReturn(gatewayPlugin);
      when(gatewayPlugin.poll(any, any, any)).thenAnswer((_) => controller.stream);

      await tester.fling(find.byType(ListView), Offset(0.0, 300.0), 1000);

      await _pumpProgressIndicator(tester);

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);

      verify(pluginManager.getGatewayPlugin());
      verify(gatewayPlugin.poll(any, any, any));

      verifyNoMoreInteractions(pluginManager);
      verifyNoMoreInteractions(gatewayPlugin);

      controller.close();
    });

    testWidgets('Sending a single event after swiping switches to a linear progress indicator', (WidgetTester tester) async {
      final StreamController<PolledPosts> controller = StreamController<PolledPosts>();

      await tester.pumpWidget(app);

      when(pluginManager.getGatewayPlugin()).thenReturn(gatewayPlugin);
      when(gatewayPlugin.poll(any, any, any)).thenAnswer((_) => controller.stream);

      await tester.fling(find.byType(ListView), Offset(0.0, 300.0), 1000);

      await _pumpProgressIndicator(tester);

      controller.sink.add(PolledPosts(0, 0, [PluginPost(1, 0, "", false)], (id) => Text(id.toString()), 3));

      await _pumpProgressIndicator(tester);

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      verify(pluginManager.getGatewayPlugin());
      verify(gatewayPlugin.poll(any, any, any));

      verifyNoMoreInteractions(pluginManager);
      verifyNoMoreInteractions(gatewayPlugin);

      controller.close();
    });

    testWidgets('After the loading is done renders widges', (WidgetTester tester) async {
      final StreamController<PolledPosts> controller = StreamController<PolledPosts>();

      await tester.pumpWidget(app);

      when(pluginManager.getGatewayPlugin()).thenReturn(gatewayPlugin);
      when(gatewayPlugin.poll(any, any, any)).thenAnswer((_) => controller.stream);

      await tester.fling(find.byType(ListView), Offset(0.0, 300.0), 1000);

      await _pumpProgressIndicator(tester);

      controller.sink.add(PolledPosts(0, 0, [PluginPost(1, 0, "", false), PluginPost(2, 0, "", false)], (id) => Text(id.toString()), 2));
      await controller.close();

      await _pumpProgressIndicator(tester);

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);

      expect(find.byType(Card), findsNWidgets(2));
      expect((find.byType(Text).evaluate().elementAt(0).widget as Text).data, "1");
      expect((find.byType(Text).evaluate().elementAt(1).widget as Text).data, "2");

      verify(pluginManager.getGatewayPlugin());
      verify(gatewayPlugin.poll(any, any, any));

      verifyNoMoreInteractions(pluginManager);
      verifyNoMoreInteractions(gatewayPlugin);

      controller.close();
    });

  });

}

Future<void> _pumpProgressIndicator(final WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}
