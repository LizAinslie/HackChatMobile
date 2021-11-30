import 'package:HackChat/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common.dart';

const defaultBaseUrl = 'https://hack.chat';

main() async {
  await Hive.initFlutter();
  Box settings = await Hive.openBox(settingsBox);

  if (!settings.containsKey('baseUrl')) {
    settings.put('baseUrl', defaultBaseUrl);
  }

  if (!settings.containsKey('darkMode')) {
    settings.put('darkMode', false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(settingsBox).listenable(),
      builder: (BuildContext context, Box settings, _) {
        bool darkMode = settings.get('darkMode', defaultValue: false);
        return MaterialApp(
          title: 'HackChat',
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.from(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              primaryVariant: Colors.deepPurpleAccent,
            ),
          ),
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
