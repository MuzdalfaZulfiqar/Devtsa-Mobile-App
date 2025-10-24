import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import 'template_a.dart';
import 'template_b.dart';

class ResumePreviewPage extends StatefulWidget { const ResumePreviewPage({super.key}); @override State<ResumePreviewPage> createState()=>_ResumePreviewPageState();}
class _ResumePreviewPageState extends State<ResumePreviewPage>{
  int templateIndex = 0;
  @override Widget build(BuildContext context){
    final resume = AppState().resume;
    final body = templateIndex==0 ? TemplateA(resume: resume) : TemplateB(resume: resume);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          DropdownButton<int>(
            value: templateIndex,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Template A')),
              DropdownMenuItem(value: 1, child: Text('Template B')),
            ],
            onChanged: (v){ setState(()=> templateIndex = v ?? 0); },
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export disabled in frontend-only demo.')));
          }, child: const Text('Export')),
        ],
      ),
      body: SingleChildScrollView(child: body),
    );
  }
}
