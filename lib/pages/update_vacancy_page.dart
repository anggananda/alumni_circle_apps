import 'dart:io';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVacancyPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final Vacancies vacancy;
  final int? page;
  const UpdateVacancyPage(
      {super.key, required this.vacancy, this.onDataSubmitted, this.page});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateVacancyPageState createState() => _UpdateVacancyPageState();
}

class _UpdateVacancyPageState extends State<UpdateVacancyPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vacancy.namaVacancy);
    _descriptionController =
        TextEditingController(text: widget.vacancy.deskripsi);
  }

  @override
  void dispose() {
    _nameController.dispose(); 
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateVacancy() async {
    String vacancyName = _nameController.text;
    String vacancyDescription = _descriptionController.text;

    if (vacancyName.isEmpty || vacancyDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the data!')));
      return;
    }

    final accessToken = context.read<AuthCubit>().state.accessToken;
    final send = context.read<VacancyCubit>(); // Gunakan DiskusiCubit
    send.updateVacancy(widget.vacancy.idVacancy, vacancyName,
        vacancyDescription, galleryFile, widget.page!, accessToken!);

    Navigator.pop(context);
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'update success.');
    } else {
      showErrorDialog(context, 'Failed to update');
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
        // iconTheme: const IconThemeData(color: Colors.white), // recolor the icon
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
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
                                        hintText: "Name Vacancy",
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
                                    width: double.infinity,
                                    height: 150,
                                    child: galleryFile == null
                                        ? Container(
                                            padding: const EdgeInsets.all(5),
                                            child: Center(
                                                child: Image.network(
                                                    '${Endpoints.urlUas}/static/storages/${widget.vacancy.gambar}')),
                                          )
                                        : Center(
                                            child: Image.file(galleryFile!),
                                          ),
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
        tooltip: 'Update Vacancy',
        onPressed: () {
          _updateVacancy();
        },
        child: const Icon(Icons.send, color: Colors.white, size: 28),
      ),
    );
  }
}
