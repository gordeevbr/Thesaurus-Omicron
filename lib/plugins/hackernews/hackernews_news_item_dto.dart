import 'package:thesaurus_omicron/plugins/plugin_post.dart';

class HackerNewsNewsItemDto extends PluginPost {

  final String _by;

  final int _descendants;

  final List<int> _kids;

  final int _score;

  final String _type;

  final String _url;

  HackerNewsNewsItemDto(this._by, this._descendants, this._kids, this._score,
      this._type, this._url, final int id, final int time, final String title
      ) : super(id, time, title, false);

  HackerNewsNewsItemDto.fromJson(Map<String, dynamic> json)
      : _by = json['by'],
        _descendants = json['descendants'],
        _kids = ((json['kids'] == null ? new List() : json['kids']) as List<dynamic>).map((x) => x as int).toList(),
        _score = json['score'],
        _type = json['type'],
        _url = json['url'],
        super(json['id'], json['time'], json['title'], false);

  String get url => _url;

  String get type => _type;

  int get score => _score;

  List<int> get kids => _kids;

  int get descendants => _descendants;

  String get by => _by;


}