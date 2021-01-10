import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thesaurus_omicron/plugins/plugin_manager.dart';
import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/plugins/polling_direction.dart';

class Home extends StatefulWidget {

  final PluginManager _pluginManager;

  Home(this._pluginManager) : super();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PolledPosts _posts = PolledPosts(0, 0, List(), (id) => null);

  Future<void> _refresh() {
    return widget._pluginManager.factories.first.construct(new Map())
        .poll(0, 50, PollingDirection.UPWARDS)
        .then((results) => setState(() {_posts = results;}), onError: (error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Thesaurus Home'),
          ),
          body: RefreshIndicator(
              child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: _posts.posts.map((post) => Card(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                      shape: Border.all(),
                      elevation: 1,
                      child: Container(
                          padding: EdgeInsets.all(2),
                          child: Function.apply(_posts.renderer, [post.batchId])
                      )
                  )).toList()
              ),
              onRefresh: _refresh
          ),
        )
    );
  }
}
