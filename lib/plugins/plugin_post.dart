class PluginPost {

  PluginPost(
      this._batchId,
      this._timestamp,
      this._title,
      this._hasPictures
  );

  final int _batchId;

  final int _timestamp;

  final String _title;

  final bool _hasPictures;

  int get batchId => _batchId;

  int get timestamp => _timestamp;

  bool get hasPictures => _hasPictures;

  String get title => _title;


}