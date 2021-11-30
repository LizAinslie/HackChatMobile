import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key, required this.text, this.icon, this.onTap}) : super(key: key);
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: icon != null ? Icon(icon, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
