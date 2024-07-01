import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateDiscussionPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final Diskusi diskusi;
  final int? page;
  const UpdateDiscussionPage({super.key, required this.diskusi, this.onDataSubmitted, this.page});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateDiscussionPageState createState() => _UpdateDiscussionPageState();
}

class _UpdateDiscussionPageState extends State<UpdateDiscussionPage> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.diskusi.subjekDiskusi) ;
    _contentController = TextEditingController(text: widget.diskusi.isiDiskusi) ;
  }

  @override
  void dispose() {
    _subjectController.dispose(); 
    _contentController.dispose(); 
    super.dispose();
  }

  void submitForm() async {
    final subject = _subjectController.text;
    final content = _contentController.text;

    if(subject.isEmpty || content.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the data!')));
      return;
    }

    final accessToken = context.read<AuthCubit>().state.accessToken;
    final update = context.read<DiskusiCubit>(); // Gunakan DiskusiCubit
    update.updateDiskusi(widget.diskusi.idDiskusi, subject, content, widget.page!, accessToken!); // Panggil method sendDiskusi
    
    Navigator.pop(context);
    if (update.state.errorMessage == '') {
      showSuccessDialog(context, 'update success.');
    } else {
      showErrorDialog(context, 'Failed to send reply');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Discussion'),
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
