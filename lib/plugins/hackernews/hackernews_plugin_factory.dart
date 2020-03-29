import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/plugin_auth.dart';
import 'package:thesaurus_omicron/plugins/plugin_factory.dart';
import 'package:thesaurus_omicron/plugins/plugin_parameter.dart';
import 'package:thesaurus_omicron/services/web_client.dart';

import 'hackernews_plugin.dart';

class HackerNewsPluginFactory extends PluginFactory {

  final WebClient _webClient;

  const HackerNewsPluginFactory(this._webClient);

  @override
  PluginAuth get authentication => new NoAuth();

  @override
  Map<String, PluginParameter> get parameters => new Map();

  @override
  Plugin construct(Map<String, PluginParameter> parameters) {
    return new HackerNewsPlugin(_webClient);
  }

}