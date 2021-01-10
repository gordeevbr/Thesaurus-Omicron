import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thesaurus_omicron/plugins/plugin_manager.dart';
import 'package:thesaurus_omicron/widgets/home.dart';

class ThesaurusApp extends StatelessWidget {

  final PluginManager _pluginManager;

  ThesaurusApp(this._pluginManager);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thesaurus Omicron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(_pluginManager),
    );
  }
}