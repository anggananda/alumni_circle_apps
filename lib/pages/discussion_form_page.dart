import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscussionFormPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final int? page;

  const DiscussionFormPage({Key? key, this.onDataSubmitted, this.page}) : super(key: key);

  @override
  _DiscussionFormPageState createState() => _DiscussionFormPageState();
}

class _DiscussionFormPageState extends State<DiscussionFormPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void submitForm() {
    final profile = context.read<ProfileCubit>();
    final currentState = profile.state;

    final idAlumni = currentState.idAlumni;
    final subject = _subjectController.text;
    final content = _contentController.text;
    final send = context.read<DiskusiCubit>(); // Gunakan DiskusiCubit
    send.sendDiskusi(idAlumni, subject, content, widget.page!); // Panggil method sendDiskusi
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Create Discussion')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Discussion'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter the discussion subject',
                filled: true,
                fillColor: thirdColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: secondaryFontColor),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Enter the discussion content',
                filled: true,
                fillColor: thirdColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: secondaryFontColor),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: submitForm, // Panggil method submitForm
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: primaryColor),
                child: Text(
                  'Post',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryFontColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
