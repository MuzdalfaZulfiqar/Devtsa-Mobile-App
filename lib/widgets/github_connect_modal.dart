// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class GitHubConnectModal extends StatelessWidget {
//   final bool open;
//   final VoidCallback onClose;

//   const GitHubConnectModal({super.key, required this.open, required this.onClose});

//   void handleConnect() async {
//     const url = "https://your-backend.com/api/users/auth/github";
//     if (await canLaunch(url)) {
//       await launch(url);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!open) return const SizedBox.shrink();

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           const Icon(Icons.code, size: 48, color: Colors.blue),
//           const SizedBox(height: 16),
//           const Text("Connect GitHub", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           const Text(
//             "To access your DevSta dashboard, please connect your GitHub account.",
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(onPressed: handleConnect, child: const Text("Connect GitHub")),
//           TextButton(onPressed: onClose, child: const Text("Close")),
//         ]),
//       ),
//     );
//   }
// // }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_providers.dart';

// class GitHubConnectModal extends StatelessWidget {
//   final bool open;
//   final VoidCallback onClose;

//   const GitHubConnectModal({super.key, required this.open, required this.onClose});

//   void handleConnect(BuildContext context) async {
//     const url = "https://devsta-backend.onrender.com/api/users/auth/github";
//     if (await canLaunch(url)) {
//       await launch(url);

//       // After user connects GitHub, refresh user data
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.fetchCurrentUser();
//       onClose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!open) return const SizedBox.shrink();

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           const Icon(Icons.code, size: 48, color: Colors.blue),
//           const SizedBox(height: 16),
//           const Text("Connect GitHub", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           const Text(
//             "To access your DevSta dashboard, please connect your GitHub account.",
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => handleConnect(context),
//             child: const Text("Connect GitHub"),
//           ),
//           TextButton(onPressed: onClose, child: const Text("Close")),
//         ]),
//       ),
//     );
//   }
// }

// widgets/github_connect_modal.dart
import 'package:flutter/foundation.dart'; // ← ADD THIS
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';

class GitHubConnectModal extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;

  const GitHubConnectModal({
    super.key,
    required this.open,
    required this.onClose,
  });

  @override
  State<GitHubConnectModal> createState() => _GitHubConnectModalState();
}

class _GitHubConnectModalState extends State<GitHubConnectModal> {
  late final WebViewController? _controller;

  @override
  void initState() {
    super.initState();

    // THIS IS THE FIX – BLOCK WEB COMPLETELY
    if (kIsWeb) {
      _controller = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("GitHub Connect is only available on mobile app"),
            backgroundColor: Colors.orange,
          ),
        );
        widget.onClose();
      });
      return;
    }

    // Only create WebView on mobile
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'receiveToken',
        onMessageReceived: (message) {
          final token = message.message;
          if (token.isNotEmpty) {
            Provider.of<AuthProvider>(context, listen: false)
                .loginWithToken(token)
                .then((_) {
              widget.onClose();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("GitHub connected successfully!")),
              );
            });
          }
        },
      )
      ..loadRequest(Uri.parse(
          'https://devsta-backend.onrender.com/api/users/auth/github'));
  }

  @override
  Widget build(BuildContext context) {
    // If on web or not open → show nothing
    if (!widget.open || kIsWeb || _controller == null) {
      return const SizedBox.shrink();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            children: [
              WebViewWidget(controller: _controller!),
              const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: widget.onClose,
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}