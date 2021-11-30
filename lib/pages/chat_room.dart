import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common.dart';
import '../components/global_drawer.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.roomName, required this.nickname}) : super(key: key);
  final String roomName;
  final String nickname;

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(settingsBox).listenable(),
      builder: (context, Box settings, _) {
        String nickname = settings.get('nickname');
        String baseUrl = settings.get('baseUrl');

        String webViewUrl = '$baseUrl?${widget.roomName}#$nickname';

        return Scaffold(
          drawer: const GlobalDrawer(),
          appBar: AppBar(
            title: Text('?${widget.roomName}'),
            actions: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.home))
            ],
          ),
          body: WebView(
            initialUrl: webViewUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              controller.loadUrl(webViewUrl);
            },
          ),
        );
      },
    );
  }
}