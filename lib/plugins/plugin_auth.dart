abstract class PluginAuth {}

class NoAuth extends PluginAuth {}

abstract class OAuth2PluginAuth extends PluginAuth {

  OAuth2PluginAuth(this._url);

  final String _url;

  String get url => _url;

}