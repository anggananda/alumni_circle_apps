import 'dart:io';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VacancyFormPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final int? page;
  const VacancyFormPage({Key? key, this.onDataSubmitted, this.page})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VacancyFormPageState createState() => _VacancyFormPageState();
}

class _VacancyFormPageState extends State<VacancyFormPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createVacancy() async {
    String vacancyName = _nameController.text;
    String vacancyDescription = _descriptionController.text;
    final title = "🎉 Lowongan Kerja Baru Telah Tersedia! ~ $vacancyName";
    const body =
        'Hai Circle Mate 👋 Ada lowongan kerja baru yang menarik di alumniCircle. Klik di sini untuk mengetahui lebih lanjut dan jangan lewatkan kesempatan emas ini! Terima kasih sudah menjadi bagian dari alumniCircle. Salam hangat, Tim alumniCircle 💞';

    debugPrint(vacancyName);

    if (vacancyName.isEmpty || vacancyDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the data!')));
      return;
    }

    final accessToken = context.read<AuthCubit>().state.accessToken;
    final token = context.read<AuthCubit>().state.token;
    final send = context.read<VacancyCubit>(); // Gunakan DiskusiCubit
    send.sendVacancy(vacancyName, vacancyDescription, galleryFile,
        widget.page!, accessToken!); // Panggil method sendDiskusi

    Navigator.pop(context);
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Post Vacancy.');
      final response = await DataService.sendNotification(
          title, body, token!, 'Data Notification', accessToken);
      if (response.statusCode == 200) {
        debugPrint('Sucessfully to send notification');
      } else {
        debugPrint('Failed to send notification ${response.statusCode}');
      }
    } else {
      showErrorDialog(context, 'Failed to post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post Vacancy 💼",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: primaryFontColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Please complete the form below to post a new vacancy. Ensure all required information is provided and an appropriate image is uploaded.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: primaryFontColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        hintText: "Vacancy Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                        hintText: "Description",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // _showPicker(context: context);
                                    ImagePickerUtil.showPicker(
                                      context: context,
                                      onImagePicked: (File? pickedFile) {
                                        setState(() {
                                          galleryFile = pickedFile;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    width:
                                        double.infinity, // Fill available space
                                    height: 150, // Adjust height as needed
                                    // color: Colors.grey[200], // Placeholder color
                                    child: galleryFile == null
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.camera_alt, size: 60, color: primaryFontColor,),
                                              Text('Pick your Image here',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: const Color.fromARGB(
                                                        255, 124, 122, 122),
                                                    fontWeight: FontWeight.w500,
                                                  ))
                                            ],
                                          ))
                                        : Center(
                                            child: Image.file(galleryFile!),
                                          ), // Placeholder text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors2,
        tooltip: 'post vacancy',
        onPressed: () {
          _createVacancy();
        },
        child: const Icon(Icons.send, color: Colors.white, size: 28),
      ),
    );
  }
}
