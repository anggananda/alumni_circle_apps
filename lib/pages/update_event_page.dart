import 'dart:io';
import 'package:alumni_circle_app/cubit/category/cubit/category_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateEventPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final Events event;
  final int? page;
  const UpdateEventPage(
      {super.key, required this.event, this.onDataSubmitted, this.page});

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _locationController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _latitudeController = TextEditingController();
  late TextEditingController _longitudeController = TextEditingController();
  late int selectedCategoryId;

  File? galleryFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.namaEvent);
    _dateController = TextEditingController(
        text: formatDateString(widget.event.tanggalEvent));
    _locationController = TextEditingController(text: widget.event.lokasi);
    _descriptionController =
        TextEditingController(text: widget.event.deskripsi);
    _latitudeController =
        TextEditingController(text: widget.event.latitude.toString());
    _longitudeController =
        TextEditingController(text: widget.event.longitude.toString());
    selectedCategoryId = widget.event.idCategory;
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

  Future<void> _updateEvent() async {
    String eventName = _nameController.text;
    String eventDate = _dateController.text;
    String eventLocation = _locationController.text;
    String eventDescription = _descriptionController.text;
    String latitude = _latitudeController.text;
    String longitude = _longitudeController.text;

    debugPrint(eventDate);

    final send = context.read<EventCubit>(); // Gunakan DiskusiCubit
    send.updateEvent(
        widget.event.idEvent,
        selectedCategoryId,
        eventName,
        eventDate,
        eventLocation,
        eventDescription,
        galleryFile,
        widget.page!,
        latitude,
        longitude);
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
                                            horizontal: 20, vertical: 12),
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
                                            padding: EdgeInsets.all(5),
                                            child: Center(
                                                child: Image.network(
                                                    '${Endpoints.urlUas}/static/storages/${widget.event.gambar}')),
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
        tooltip: 'Increment',
        onPressed: () {
          _updateEvent();
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
