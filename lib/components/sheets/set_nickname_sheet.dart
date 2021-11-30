import 'package:flutter/material.dart';

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