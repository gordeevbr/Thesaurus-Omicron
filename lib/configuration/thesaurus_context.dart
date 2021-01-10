
import 'package:thesaurus_omicron/plugins/hackernews/hackernews_plugin_factory.dart';
import 'package:thesaurus_omicron/plugins/plugin_manager.dart';
import 'package:thesaurus_omicron/services/std_web_client.dart';
import 'package:thesaurus_omicron/services/web_client.dart';
import 'package:thesaurus_omicron/thesaurus_app.dart';

class ThesaurusContext {

  final WebClient webClient;

  final HackerNewsPluginFactory hackerNewsPluginFactory;

  final PluginManager pluginManager;

  final ThesaurusApp app;

  ThesaurusContext._internal(
      this.webClient,
      this.hackerNewsPluginFactory,
      this.pluginManager,
      this.app
  );

  factory ThesaurusContext() {
    final webClient = StdWebClient();
    final hackerNewsPluginFactory = HackerNewsPluginFactory(webClient);
    final pluginManager = PluginManager(List.from([hackerNewsPluginFactory], growable: false));
    final app = ThesaurusApp(pluginManager);
    return ThesaurusContext._internal(
      webClient,
      hackerNewsPluginFactory,
      pluginManager,
      app
    );
  }

}