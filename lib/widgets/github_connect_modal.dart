import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubConnectModal extends StatelessWidget {
  final bool open;
  final VoidCallback onClose;

  const GitHubConnectModal({super.key, required this.open, required this.onClose});

  void handleConnect() async {
    const url = "https://your-backend.com/api/users/auth/github";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!open) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.code, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          const Text("Connect GitHub", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            "To access your DevSta dashboard, please connect your GitHub account.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: handleConnect, child: const Text("Connect GitHub")),
          TextButton(onPressed: onClose, child: const Text("Close")),
        ]),
      ),
    );
  }
}
