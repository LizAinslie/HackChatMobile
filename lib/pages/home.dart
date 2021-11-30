import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common.dart';
import '../components/global_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(settingsBox).listenable(),
      builder: (context, Box settings, widget) {
        String baseUrl = settings.get('baseUrl');

        return Scaffold(
          drawer: const GlobalDrawer(),
          appBar: AppBar(
            title: Text(Uri.parse(baseUrl).host),
          ),
          body: WebView(
            initialUrl: baseUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              controller.loadUrl(baseUrl);
            },
          ),
        );
      },
    );
  }
}