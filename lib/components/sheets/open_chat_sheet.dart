import 'package:flutter/material.dart';

import '../../common.dart';

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
                    openRoomPage(context, _textFieldText);
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