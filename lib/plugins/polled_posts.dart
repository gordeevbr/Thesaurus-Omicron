import 'package:flutter/widgets.dart';
import 'package:thesaurus_omicron/plugins/plugin_post.dart';

typedef WidgetById = Widget Function(int);

class PolledPosts {

  PolledPosts(this._upperOffset, this._lowerOffset, this._posts, this._renderer);

  final int _upperOffset;

  final int _lowerOffset;

  final List<PluginPost> _posts;

  final WidgetById _renderer;

  int get upperOffset => _upperOffset;

  int get lowerOffset => _lowerOffset;

  List<PluginPost> get posts => _posts;

  WidgetById get renderer => _renderer;

}