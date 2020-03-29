import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:thesaurus_omicron/plugins/hackernews/hackernews_news_item_dto.dart';
import 'package:thesaurus_omicron/plugins/plugin.dart';
import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/plugins/polling_direction.dart';
import 'package:thesaurus_omicron/services/web_client.dart';
import 'package:url_launcher/url_launcher.dart';

class HackerNewsPlugin extends Plugin {

  static const String _NEW_STORIES =
      "https://hacker-news.firebaseio.com/v0/newstories.json";

  static const String _POST_URL =
      "https://hacker-news.firebaseio.com/v0/item/{postid}.json";

  static const String _HACKER_NEWS_URL =
      "https://news.ycombinator.com";

  static const String _URL_PATTERN =
      "^([a-zA-Z]+:\/\/[a-zA-Z0-9.-]+)\/?.*";

  static const String _POST_COMMENTS_URL =
      "https://news.ycombinator.com/item?id={postid}";

  final WebClient _webClient;

  const HackerNewsPlugin(this._webClient): super();

  @override
  Future<PolledPosts> poll(final int offset, final int limit, final PollingDirection direction) {
    final latest = _loadLatest();
    return latest;
  }

  Future<PolledPosts> _loadLatest() async {
    final links = await _webClient
        .read(_NEW_STORIES, "GET", (body) => { (json.decode(body) as List).map((x) => x as int) })
        .then((values) => values.first.map((postId) => _POST_URL.replaceAll("{postid}", postId.toString())).toList());
    final parsedPosts = await _webClient.readMany(links, "GET", (body) => HackerNewsNewsItemDto.fromJson(json.decode(body)));
    final nonNullParsedPosts = parsedPosts.where((x) => x != null).toList();
    return new PolledPosts(
        nonNullParsedPosts.map((item) => item.timestamp).reduce((a, b) => max(a, b)),
        nonNullParsedPosts.map((item) => item.timestamp).reduce((a, b) => min(a, b)),
        nonNullParsedPosts,
        this._generateWidget(nonNullParsedPosts)
    );
  }

  WidgetById _generateWidget(final List<HackerNewsNewsItemDto> posts) => (final int postId) {
    final HackerNewsNewsItemDto post = posts.firstWhere(
            (item) => item.batchId == postId,
        orElse: () => throw ArgumentError("Post with id $postId does not belong to this batch")
    );
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Image(image: AssetImage('assets/icons/y18.gif')),
            title: Text(post.title),
            subtitle: Text("${_resolveUrl(post)}\n${_formatDate(post.timestamp)}"),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            dense: true,
          ),
          ButtonBar(
              children: _getButtons(post),
              buttonPadding: EdgeInsets.all(0),
              buttonHeight: 5,
          )
        ]
    );
  };

  String _formatDate(final int date) {
    return new DateFormat.yMd().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
  }

  String _resolveUrl(final HackerNewsNewsItemDto post) {
    if (post.url == null) {
      return _HACKER_NEWS_URL;
    }

    final RegExp pattern = RegExp(_URL_PATTERN);
    if (pattern.hasMatch(post.url)) {
      final RegExpMatch match = pattern.firstMatch(post.url);
      return match.group(1);
    } else {
      return post.url;
    }
  }

  List<Widget> _getButtons(final HackerNewsNewsItemDto post) {
    final String commentUrl = _POST_COMMENTS_URL.replaceAll("{postid}", post.batchId.toString());
    if (post.url == null) {
      return [
        FlatButton(
          child: const Text('Comments'),
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          onPressed: () { _followUrl(commentUrl); }
        )
      ];
    } else {
      return [
        FlatButton(
          child: const Text('Comments'),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          onPressed: () async { await _followUrl(commentUrl); }
        ),
        FlatButton(
          child: const Text('Article'),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          onPressed: () async { await _followUrl(post.url); }
        )
      ];
    }
  }

  Future<void> _followUrl(final String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open $url';
    }
  }

}