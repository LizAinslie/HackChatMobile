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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackChat',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}
