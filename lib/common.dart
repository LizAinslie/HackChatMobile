import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/sheets/open_chat_sheet.dart';
import 'components/sheets/set_text_sheet.dart';

import 'pages/chat_room.dart';

const settingsBox = 'settings';

void openRoomPage(BuildContext context, String roomName) {
  Box settings = Hive.box(settingsBox);

  if (settings.containsKey('nickname')) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
      roomName: roomName,
      nickname: settings.get('nickname'),
    )));
  } else {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SetTextSheet(
          header: 'Set your nickname',
          onInput: (text) {
            settings.put('nickname', text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
              roomName: roomName,
              nickname: text
            )));
          },
        );
      },
    );
  }
}

void openChat(BuildContext context) {
  showModalBottomSheet(
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