import 'dart:io';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateEventPage extends StatefulWidget {
  final VoidCallback? onDataSubmitted;
  final Events event;
  final int? page;
  const UpdateEventPage({super.key, required this.event, this.onDataSubmitted, this.page});

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _locationController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();


  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(text: widget.event.namaEvent);
    _dateController = TextEditingController(text: formatDateString(widget.event.tanggalEvent));
    _locationController = TextEditingController(text: widget.event.lokasi);
    _descriptionController = TextEditingController(text: widget.event.deskripsi);
  }

  _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose of controller when widget is removed
    super.dispose();
  }

  Future<void> _updateEvent() async {
    String eventName = _nameController.text;
    String eventDate = _dateController.text;
    String eventLocation = _locationController.text;
    String eventDescription = _descriptionController.text;

    debugPrint(eventDate);

  final send = context.read<EventCubit>(); // Gunakan DiskusiCubit
    send.updateEvent(widget.event.idEvent, eventName, eventDate, eventLocation, eventDescription, galleryFile, widget.page!); 
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Update Event')));
    Navigator.pop(context);
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
                    "Update Events 🍀",
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
                    "Fill in the data below, make sure you add the data and upload the image",
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
                                GestureDetector(
                                  onTap: () {
                                    _showPicker(context: context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    width:
                                        double.infinity, 
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
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Increment',
        onPressed: () {
          _updateEvent();
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
