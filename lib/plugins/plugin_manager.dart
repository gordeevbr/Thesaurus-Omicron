
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/plugin_aggregate.dart';
import 'package:thesaurus_omicron/plugins/plugin_factory.dart';

class PluginManager {

  final Iterable<PluginFactory> _factories;

  PluginManager(this._factories);
  
  Plugin getGatewayPlugin() {
    return _factories
        .map((factory) => factory.construct(Map()))
        .reduce((left, right) => PluginAggregate(left, right));
  }

}