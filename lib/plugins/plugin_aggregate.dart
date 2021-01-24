import 'dart:async';

import 'package:stream_transform/stream_transform.dart';
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/plugins/polling_direction.dart';

class PluginAggregate extends Plugin {

  final Plugin _left;

  final Plugin _right;

  PluginAggregate(this._left, this._right);

  @override
  Stream<PolledPosts> poll(int offset, int limit, PollingDirection direction) {
    final leftResult = _left.poll(offset, limit, direction);
    final rightResult = _right.poll(offset, limit, direction);
    return leftResult.combineLatest(rightResult, (left, right) => left); // TODO define this behavior later when you have multiple plugins
  }

}