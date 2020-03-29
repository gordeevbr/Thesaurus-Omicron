import 'package:thesaurus_omicron/plugins/hackernews/hackernews_plugin_factory.dart';
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/plugin_auth.dart';
import 'package:thesaurus_omicron/plugins/plugin_parameter.dart';
import 'package:thesaurus_omicron/services/std_web_client.dart';
import 'package:thesaurus_omicron/services/web_client.dart';

abstract class PluginFactory {

  static final WebClient _webClient = new StdWebClient();

  const PluginFactory();

  static List<PluginFactory> getAll() {
    // Without any reflection or DI libraries, I have to do this explicitly
    return [new HackerNewsPluginFactory(_webClient)];
  }

  PluginAuth get authentication;

  Map<String, PluginParameter> get parameters;

  Plugin construct(final Map<String, PluginParameter> parameters);

}

