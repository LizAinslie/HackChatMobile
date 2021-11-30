import 'package:flutter/material.dart';

class SetTextSheet extends StatefulWidget {
  const SetTextSheet({Key? key, required this.onInput, required this.header, this.initialValue = ''}) : super(key: key);
  final void Function(String) onInput;
  final String header;
  final String initialValue;

  @override
  _SetTextSheetState createState() => _SetTextSheetState();
}
class _SetTextSheetState extends State<SetTextSheet> {
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
          Text(widget.header,
            style: Theme.of(context).textTheme.headline5,
          ),
          TextFormField(
            initialValue: widget.initialValue,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}