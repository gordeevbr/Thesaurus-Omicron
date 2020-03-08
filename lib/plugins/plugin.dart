import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/plugins/polling_direction.dart';

abstract class Plugin {

  Future<PolledPosts> poll(final int offset, final int limit, final PollingDirection direction);

}