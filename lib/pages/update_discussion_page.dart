import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/utils/constants.dart';
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

  void submitForm() async {
    final subject = _subjectController.text;
    final content = _contentController.text;

    debugPrint(
        'Submitting discussion: Subject - $subject, Content - $content, idAlumni');

    // final response = await DataService.updateDiskusi(widget.diskusi.idDiskusi, subject, content);

    // if (response.statusCode == 200) {
    //   debugPrint('Update Discussion success');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Update Discussion success')));
    //   widget.onDataSubmitted?.call(); // Panggil callback di sini
    //   Navigator.pop(context);
    // } else {
    //   debugPrint('Failed: ${response.statusCode}');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed: ${response.statusCode}')));
    // }

    final update = context.read<DiskusiCubit>(); // Gunakan DiskusiCubit
    update.updateDiskusi(widget.diskusi.idDiskusi, subject, content, widget.page!); // Panggil method sendDiskusi
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Update Discussion')));
    Navigator.pop(context);
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
                onPressed: () {
                  submitForm();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: primaryColor),
                child: Text(
                  'Update',
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
