import 'package:flutter/material.dart';

PreferredSizeWidget appBarWithBorder(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title),
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    actions: actions,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.25),
      ),
    ),
  );
}
