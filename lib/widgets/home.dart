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

  Stream<PolledPosts> _stream;

  PolledPosts _posts = PolledPosts(0, 0, List(), (id) => null, 0);

  Future<void> _refresh() {
    setState(() {
      this._stream = widget._pluginManager.factories.first.construct(new Map())
          .poll(0, 50, PollingDirection.UPWARDS);
    });
    return Future.value(null);
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
              child: _renderContentLoading(),
              onRefresh: _refresh,
            )
        )
    );
  }

  Widget _renderContentLoading() {
    return StreamBuilder(
        initialData: PolledPosts(0, 0, List(), null, 0),
        stream: this._stream,
        builder: (context, AsyncSnapshot<PolledPosts> snapshot) {
          if (snapshot.hasError) {
            return _renderError(snapshot.error);
          }

          if (snapshot.connectionState == ConnectionState.active) {
            return LinearProgressIndicator(value: snapshot.data.posts.length / snapshot.data.expectedTotalCount);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(value: null)
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._posts = snapshot.data;
          }

          return _renderBody();
        }
    );
  }

  Widget _renderBody() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _posts.posts.map((post) => Card(
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          shape: Border.all(),
          elevation: 1,
          child: Container(
              padding: EdgeInsets.all(2),
              child: Function.apply(_posts.renderer, [post.batchId])
          )
      )).toList(),
      physics: AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _renderError(final Object error) {
    print(error);
    if (error is Exception) {
      return Text(error.toString());
    } else if (error is String) {
      return Text(error);
    } else {
      return Text("Unknown error has occurred");
    }
  }
}
