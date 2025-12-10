// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class ResumeUploadModal extends StatefulWidget {
//   final bool open;
//   final VoidCallback onClose;
//   final Function(String filePath) onUpload;

//   const ResumeUploadModal({super.key, required this.open, required this.onClose, required this.onUpload});

//   @override
//   State<ResumeUploadModal> createState() => _ResumeUploadModalState();
// }

// class _ResumeUploadModalState extends State<ResumeUploadModal> {
//   String? filePath;

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );
//     if (result != null) {
//       setState(() {
//         filePath = result.files.single.path;
//       });
//     }
//   }

//   void handleUpload() {
//     if (filePath != null) {
//       widget.onUpload(filePath!);
//       setState(() {
//         filePath = null;
//       });
//       widget.onClose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.open) return const SizedBox.shrink();

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           const Icon(Icons.upload_file, size: 48, color: Colors.blue),
//           const SizedBox(height: 16),
//           const Text("Upload Resume", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           if (filePath == null)
//             ElevatedButton(onPressed: pickFile, child: const Text("Choose File"))
//           else ...[
//             Text(filePath!.split('/').last),
//             const SizedBox(height: 8),
//             ElevatedButton(onPressed: handleUpload, child: const Text("Upload")),
//             TextButton(onPressed: () => setState(() => filePath = null), child: const Text("Cancel")),
//           ],
//           TextButton(onPressed: widget.onClose, child: const Text("Close")),
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';
import 'dart:typed_data';

class ResumeUploadModal extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;

  const ResumeUploadModal({super.key, required this.open, required this.onClose});

  @override
  State<ResumeUploadModal> createState() => _ResumeUploadModalState();
}

class _ResumeUploadModalState extends State<ResumeUploadModal> {
  PlatformFile? pickedFile;
  bool uploading = false;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }
void handleUpload() async {
  if (pickedFile == null) return;

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  if (authProvider.token == null) return;

  if (mounted) setState(() => uploading = true);

  try {
    var uri = Uri.parse('https://devsta-backend.onrender.com/api/users/resume');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${authProvider.token}';

    if (pickedFile!.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'resume',
          pickedFile!.bytes!,
          filename: pickedFile!.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      await authProvider.fetchCurrentUser();

      // reset state safely before closing
      if (mounted) {
        setState(() {
          pickedFile = null;
          uploading = false;
        });
      }

      widget.onClose();
    } else {
      final respStr = await response.stream.bytesToString();
      print("Resume upload failed: $respStr");
      if (mounted) setState(() => uploading = false);
    }
  } catch (e) {
    print("Resume upload error: $e");
    if (mounted) setState(() => uploading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.upload_file, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          const Text("Upload Resume", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (pickedFile == null)
            ElevatedButton(onPressed: pickFile, child: const Text("Choose File"))
          else ...[
            Text(pickedFile!.name),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: uploading ? null : handleUpload,
              child: uploading ? const CircularProgressIndicator() : const Text("Upload"),
            ),
            TextButton(onPressed: () => setState(() => pickedFile = null), child: const Text("Cancel")),
          ],
          TextButton(onPressed: widget.onClose, child: const Text("Close")),
        ]),
      ),
    );
  }
}
