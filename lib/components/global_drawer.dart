import 'package:HackChat/components/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../pages/pinned_rooms.dart';
import '../pages/settings.dart';
import '../common.dart';

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(settingsBox).listenable(),
      builder: (context, Box settings, widget) {
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
                    Text(Uri.parse(settings.get('baseUrl')).host,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              DrawerItem(
                text: 'Create / Join a room',
                icon: Icons.add,
                onTap: () {
                  openChat(context);
                },
              ),
              DrawerItem(
                text: 'Pinned Rooms',
                icon: Icons.push_pin,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PinnedRoomsPage()));
                },
              ),
              DrawerItem(
                text: 'Settings',
                icon: Icons.settings,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}