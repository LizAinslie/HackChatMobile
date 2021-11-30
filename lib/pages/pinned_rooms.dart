import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';
import '../data/pinned_room.dart';

class PinnedRoomsPage extends StatefulWidget {
  const PinnedRoomsPage({Key? key}) : super(key: key);

  @override
  _PinnedRoomsPageState createState() => _PinnedRoomsPageState();
}

class _PinnedRoomsPageState extends State<PinnedRoomsPage> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<PinnedRoom>(pinnedRoomsBox).listenable(),
      builder: (context, Box<PinnedRoom> rooms, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pinned Rooms'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _editing = !_editing;
                  });
                },
                icon: Icon(_editing ? Icons.close : Icons.edit),
              ),
            ],
          ),
          body: Center(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: rooms.length,
              itemBuilder: (context, i) {
                PinnedRoom room = rooms.getAt(i)!;

                return ListTile(
                  title: Text('?${room.roomName}'),
                  trailing: _editing ? IconButton(
                    onPressed: () {
                      room.delete();
                    },
                    icon: const Icon(Icons.delete)
                  ) : null,
                  onTap: _editing ? null : () { // Do nothing if you tap the item while in edit mode
                    openRoomPage(context, room.roomName);
                  },
                );
              },
              separatorBuilder: (context, i) {
                return const Divider();
              }
            ),
          ),
        );
      },
    );
  }
}
