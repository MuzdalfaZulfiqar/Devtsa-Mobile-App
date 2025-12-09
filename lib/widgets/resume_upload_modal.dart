import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ResumeUploadModal extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;
  final Function(String filePath) onUpload;

  const ResumeUploadModal({super.key, required this.open, required this.onClose, required this.onUpload});

  @override
  State<ResumeUploadModal> createState() => _ResumeUploadModalState();
}

class _ResumeUploadModalState extends State<ResumeUploadModal> {
  String? filePath;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  void handleUpload() {
    if (filePath != null) {
      widget.onUpload(filePath!);
      setState(() {
        filePath = null;
      });
      widget.onClose();
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
          if (filePath == null)
            ElevatedButton(onPressed: pickFile, child: const Text("Choose File"))
          else ...[
            Text(filePath!.split('/').last),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: handleUpload, child: const Text("Upload")),
            TextButton(onPressed: () => setState(() => filePath = null), child: const Text("Cancel")),
          ],
          TextButton(onPressed: widget.onClose, child: const Text("Close")),
        ]),
      ),
    );
  }
}
