import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';
import '../data/pinned_room.dart';

class RoomSettingsPage extends StatefulWidget {
  const RoomSettingsPage({Key? key, required this.roomName}) : super(key: key);
  final String roomName;

  @override
  _RoomSettingsPageState createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<PinnedRoom>(pinnedRoomsBox).listenable(),
      builder: (context, Box<PinnedRoom> pinnedRooms, _) {
        bool isPinned = pinnedRooms.values.any((room) => room.roomName == widget.roomName);

        return Scaffold(
          appBar: AppBar(
            title: Text('Settings for ?${widget.roomName}'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isPinned) {
                        PinnedRoom pinnedRoom = pinnedRooms.values.singleWhere((room) => room.roomName == widget.roomName);
                        pinnedRoom.delete();
                      } else {
                        pinnedRooms.add(PinnedRoom(widget.roomName));
                      }
                    },
                    child: Text(isPinned ? 'Unpin Room' : 'Pin Room'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
