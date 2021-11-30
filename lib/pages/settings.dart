import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';
import '../components/sheets/set_text_sheet.dart';

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
        title: const Text('Settings'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(settingsBox).listenable(),
        builder: (context, Box settings, _) {
          bool darkMode = settings.get('darkMode', defaultValue: false);
          String baseUrl = settings.get('baseUrl');
          String nickname = settings.get('nickname');

          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Base URL'),
                  subtitle: Text(baseUrl),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SetTextSheet(
                          header: 'Set a base URL',
                          initialValue: baseUrl,
                          onInput: (text) {
                            settings.put('baseUrl', text);
                          }
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Nickname'),
                  subtitle: Text(nickname),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SetTextSheet(
                          header: 'Set your nickname',
                          initialValue: nickname,
                          onInput: (text) {
                            settings.put('nickname', text);
                          }
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Icon(
                    darkMode ? Icons.check_box : Icons.check_box_outline_blank,
                    semanticLabel: darkMode ? 'Disable Dark Mode' : 'Enable Dark Mode',
                  ),
                  onTap: () {
                    settings.put('darkMode', !darkMode);
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