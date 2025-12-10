import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ResumeViewer extends StatefulWidget {
  final String url;
  const ResumeViewer({super.key, required this.url});

  @override
  State<ResumeViewer> createState() => _ResumeViewerState();
}

class _ResumeViewerState extends State<ResumeViewer> {
  String? localPath;
  bool loading = true;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/resume.pdf";

      await Dio().download(
        widget.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() {
        localPath = filePath;
        loading = false;
      });
    } catch (e) {
      debugPrint("Failed to download PDF: $e");
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load resume.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resume")),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Loading Resume..."),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(value: progress),
                  const SizedBox(height: 10),
                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ],
              ),
            )
          : localPath != null
              ? SfPdfViewer.file(File(localPath!))
              : const Center(child: Text("Failed to load resume.")),
    );
  }
}
