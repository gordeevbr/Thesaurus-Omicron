abstract class PluginParameter {
  bool get isRequired;
}

class StringParameter extends PluginParameter {

  StringParameter(this._value, this._isRequired);

  final String _value;

  final bool _isRequired;

  String get value => _value;

  @override
  bool get isRequired => _isRequired;

}

class StringCollectionParameter extends PluginParameter {

  StringCollectionParameter(this._value, this._isRequired);

  final List<String> _value;

  final bool _isRequired;

  List<String> get value => _value;

  @override
  bool get isRequired => _isRequired;

}