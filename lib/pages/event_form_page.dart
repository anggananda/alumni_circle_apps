import 'dart:io';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/category/cubit/category_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EventFormPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final int? page;
  const EventFormPage({Key? key, this.onDataSubmitted, this.page})
      : super(key: key);

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _createEvent() async {
    String eventName = _nameController.text;
    String eventDate = _dateController.text;
    String eventLocation = _locationController.text;
    String eventDescription = _descriptionController.text;
    String latitude = _latitudeController.text;
    String longitude = _longitudeController.text;
    final title = "🎉 Event Baru Telah Hadir! ~ ${eventName}";
    const body =
        '''Hai Circle Mate 👋 Jangan lewatkan event terbaru yang telah kami posting. Klik di sini untuk mengetahui lebih lanjut dan bergabunglah dengan keseruan acara ini! Terima kasih telah menjadi bagian dari komunitas kami. Salam hangat, Tim AlumniCircle 💞''';

    debugPrint(selectedCategoryId.toString());

    if (eventName.isEmpty &&
        eventDate.isEmpty &&
        eventLocation.isEmpty &&
        eventDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the data!')));
      return;
    }

    final acessToken = context.read<AuthCubit>().state.accessToken;
    final token = context.read<AuthCubit>().state.token;
    final send = context.read<EventCubit>(); // Gunakan DiskusiCubit
    send.sendEvent(selectedCategoryId!, eventName, eventDate, eventLocation,
        eventDescription, galleryFile, widget.page!, latitude, longitude);
    Navigator.pop(context);
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Post Event');
      final response = await DataService.sendNotification(
          title, body, token!, 'Data Notification', acessToken!);
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
                      "Post Event 🎊",
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
                      "Please fill in the details below and upload an image to create your event.",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: primaryFontColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )),
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
                                        hintText: "Name Event",
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
                                    controller: _dateController,
                                    decoration: const InputDecoration(
                                        hintText: "Date",
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
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                        hintText: "Location",
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
                                BlocBuilder<CategoryCubit, CategoryState>(
                                  builder: (context, state) {
                                    return DropdownButtonFormField<int>(
                                      value: selectedCategoryId,
                                      items: state.categoryList.map((category) {
                                        return DropdownMenuItem<int>(
                                          value: category.idCategory,
                                          child: Text(
                                            category.nameCategory,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors
                                                  .black, // Sesuaikan dengan warna teks yang diinginkan
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategoryId = value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 12),
                                        labelText: 'Category',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder
                                            .none, // Menghilangkan outline
                                        focusedBorder: InputBorder
                                            .none, // Menghilangkan outline saat focus
                                      ),
                                    );
                                  },
                                ),
                                Divider(color: Colors.grey.shade200),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _latitudeController,
                                    decoration: const InputDecoration(
                                        hintText: "latitude",
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
                                    controller: _longitudeController,
                                    decoration: const InputDecoration(
                                        hintText: "longitude",
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
                                              Icon(Icons.camera_alt, size: 60, color: primaryFontColor,),
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
        tooltip: 'Post Event',
        onPressed: () {
          _createEvent();
        },
        child: const Icon(Icons.send, color: Colors.white, size: 28),
      ),
    );
  }
}
