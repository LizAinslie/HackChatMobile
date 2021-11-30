import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultBaseUrl = 'https://hack.chat';
const settingsBox = 'settings';

main() async {
  await Hive.initFlutter();
  Box settings = await Hive.openBox(settingsBox);

  if (!settings.containsKey('baseUrl')) {
    settings.put('baseUrl', defaultBaseUrl);
  }

  runApp(const MyApp());
}

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, widget) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Column(
                  children: [
                    const Text('HackChat',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    Text(Uri.parse(box.get('baseUrl')).host,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Create / Join a room'),
                onTap: () {
                  openChat(context);
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
              ),
            ],
          ),
        );
      }
    );
  }
}

class SetNicknameSheet extends StatefulWidget {
  const SetNicknameSheet({Key? key, required this.onInput}) : super(key: key);
  final void Function(String) onInput;

  @override
  _SetNicknameSheetState createState() => _SetNicknameSheetState();
}
class _SetNicknameSheetState extends State<SetNicknameSheet> {
  String _textFieldText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Set a nickname'),
          TextField(
            onChanged: (text) {
              setState(() {
                _textFieldText = text;
              });
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Set'),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onInput(_textFieldText);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OpenChatSheet extends StatefulWidget {
  const OpenChatSheet({Key? key}) : super(key: key);

  @override
  _OpenChatSheetState createState() => _OpenChatSheetState();
}
class _OpenChatSheetState extends State<OpenChatSheet> {
  String _textFieldText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Join or create a room'),
          TextField(
            onChanged: (text) {
              setState(() {
                _textFieldText = text;
              });
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Join'),
                  onPressed: () {
                    Navigator.pop(context);
                    _openRoomPage(context, _textFieldText);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

void _openRoomPage(BuildContext context, String roomName) {
  Box box = Hive.box(settingsBox);

  if (box.containsKey('nickname')) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
      roomName: roomName,
      nickname: box.get('nickname'),
    )));
  } else {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SetNicknameSheet(onInput: (text) {
          box.put('nickname', text);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
            roomName: roomName,
            nickname: text
          )));
        });
      },
    );
  }
}
void openChat(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const OpenChatSheet();
    },
  );
}
void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Unable to launch URL: $url';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(settingsBox);
    String baseUrl = box.get('baseUrl');

    return MaterialApp(
      title: 'HackChat',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: Uri.parse(baseUrl).host),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, widget) {
        String baseUrl = box.get('baseUrl');
        return Scaffold(
          drawer: const GlobalDrawer(),
          appBar: AppBar(
            title: Text(Uri
            .parse(baseUrl)
            .host),
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
    Box box = Hive.box(settingsBox);
    String baseUrl = box.get('baseUrl');

    String roomName = widget.roomName;

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
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, widget) {
          return WebView(
            initialUrl: '$baseUrl?$roomName#${box.get('nickname')}',
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, widget) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Base URL',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextFormField(
                  initialValue: box.get('baseUrl'),
                  onChanged: (text) {
                    box.put('baseUrl', text);
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 16),
                  child: Text('Nickname',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                TextFormField(
                  initialValue: box.get('nickname'),
                  onChanged: (text) {
                    box.put('nickname', text);
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

