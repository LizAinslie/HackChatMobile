import 'package:hive/hive.dart';

class PinnedRoom extends HiveObject {
  PinnedRoom(this.roomName);
  String roomName;
}

class PinnedRoomAdapter extends TypeAdapter<PinnedRoom> {
  @override
  PinnedRoom read(BinaryReader reader) {
    String roomName = reader.readString();

    return PinnedRoom(roomName);
  }

  @override
  final int typeId = 0;

  @override
  void write(BinaryWriter writer, PinnedRoom obj) {
    writer.writeString(obj.roomName);
  }
}