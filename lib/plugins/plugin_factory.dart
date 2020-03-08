import 'package:thesaurus_omicron/plugins/hackernews/hackernews_plugin_factory.dart';
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/plugin_auth.dart';
import 'package:thesaurus_omicron/plugins/plugin_parameter.dart';

abstract class PluginFactory {

  const PluginFactory();

  static List<PluginFactory> getAll() {
    // Without any reflection or DI libraries, I have to do this explicitly
    return const [const HackerNewsPluginFactory()];
  }

  PluginAuth get authentication;

  Map<String, PluginParameter> get parameters;

  Plugin construct(final Map<String, PluginParameter> parameters);

}

