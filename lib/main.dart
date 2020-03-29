import 'package:flutter/material.dart';
import 'package:thesaurus_omicron/plugins/plugin_factory.dart';
import 'package:thesaurus_omicron/plugins/polled_posts.dart';
import 'package:thesaurus_omicron/plugins/polling_direction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thesaurus Omicron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Thesaurus Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PolledPosts _posts = PolledPosts(0, 0, List(), (id) => null);

  Future<void> _refresh() {
    return PluginFactory.getAll().first.construct(new Map())
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
            title: Text(widget.title),
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
