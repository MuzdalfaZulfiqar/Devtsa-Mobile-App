import 'package:flutter/material.dart';

class InfoModal extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const InfoModal({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onClose,
              child: const Text("Close"),
            )
          ],
        ),
      ),
      child: const Icon(Icons.info),
    );
  }
}
