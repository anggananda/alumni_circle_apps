import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscussionFormPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final int? page;

  const DiscussionFormPage({Key? key, this.onDataSubmitted, this.page}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DiscussionFormPageState createState() => _DiscussionFormPageState();
}

class _DiscussionFormPageState extends State<DiscussionFormPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose(); 
    _contentController.dispose(); 
    super.dispose();
  }

  void submitForm() {
    final profile = context.read<ProfileCubit>();
    final currentState = profile.state;

    final idAlumni = currentState.idAlumni;
    final subject = _subjectController.text;
    final content = _contentController.text;

    if (subject.isEmpty && content.isEmpty) {
    // Both subject and content are empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in both subject and content')),
    );
    return;
  } else if (subject.isEmpty || content.isEmpty) {
    // Either subject or content is empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in both subject and content')),
    );
    return;
  }

    final accessToken = context.read<AuthCubit>().state.accessToken;
    final send = context.read<DiskusiCubit>(); // Gunakan DiskusiCubit
    send.sendDiskusi(idAlumni, subject, content, widget.page!, accessToken!); // Panggil method sendDiskusi
    Navigator.pop(context);
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'post success.');
    } else {
      showErrorDialog(context, 'Failed to post');
    }
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
      Container(
        decoration: BoxDecoration(
          color: thirdColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              hintText: 'Enter the discussion subject',
              border: InputBorder.none,
              hintStyle: TextStyle(color: secondaryFontColor),
            ),
          ),
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
      Container(
        decoration: BoxDecoration(
          color: thirdColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(
              hintText: 'Enter the discussion content',
              border: InputBorder.none,
              hintStyle: TextStyle(color: secondaryFontColor),
            ),
            maxLines: 4,
          ),
        ),
      ),
      const SizedBox(height: 30),
      Center(
        child: ElevatedButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: colors2,
            elevation: 5, // Tambahkan elevasi untuk memberi efek shadow pada tombol
          ),
          child: const Text(
            'Post',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    ],
  ),
)
    );
  }
}
