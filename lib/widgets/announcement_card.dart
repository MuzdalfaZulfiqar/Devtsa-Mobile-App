import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String message;

  const AnnouncementCard({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow.shade50,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
        leading: const Icon(Icons.announcement, color: Colors.orange),
      ),
    );
  }
}
