import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings')
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(settingsBox).listenable(),
        builder: (context, Box settings, widget) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Base URL',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextFormField(
                  initialValue: settings.get('baseUrl'),
                  onChanged: (text) {
                    settings.put('baseUrl', text);
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 16),
                  child: Text('Nickname',
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                TextFormField(
                  initialValue: settings.get('nickname'),
                  onChanged: (text) {
                    settings.put('nickname', text);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}