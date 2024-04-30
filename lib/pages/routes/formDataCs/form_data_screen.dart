import 'dart:convert';
import 'dart:io';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FormDataScreen extends StatefulWidget {
  const FormDataScreen({Key? key}) : super(key: key);

  @override
  _FormDataScreenState createState() => _FormDataScreenState();
}

class _FormDataScreenState extends State<FormDataScreen> {
  // final _nimController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final _ratingController = TextEditingController();
  int _rating = 0;
  // String _title = "";
  // String _divisionTarget = ''; // Nilai default untuk division target
  String _priority = 'high'; // Nilai default untuk priority

  // List<String> _divisionTargets = [];
  // String _priority = 'high';

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': 1,
  //     'type': _divisionTargets,
  //   };
  // }

  // String encodeJson() {
  //   return jsonEncode(toJson());
  // }

  // List<Map<String, dynamic>> _checkboxData = [
  //   {"id": 1, "type": "Billing"},
  //   {"id": 2, "type": "Support"},
  //   {"id": 3, "type": "Teknis"},
  // ];

  // List<String> _selectedTypes = [];

  List<Map<String, dynamic>> _checkboxData = [
    {"id": 1, "type": "Billing"},
    {"id": 2, "type": "Support"},
    {"id": 3, "type": "Teknis"},
  ];

  String? _selectedType;

  File? galleryFile;
  final picker = ImagePicker();

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
    _titleController.dispose(); // Dispose of controller when widget is removed
    super.dispose();
  }

  // saveData() {
  //   debugPrint(_title);
  // }

  Future<void> _postDataWithImage(BuildContext context) async {
    final title = _titleController.text;
    // final nim = _nimController.text;
    final description = _descriptionController.text;
    // final rating = _ratingController.text;
    final rating = _rating.toString();

    if (galleryFile == null) {
      return; // Handle case where no image is selected
    }

    var request = MultipartRequest('POST', Uri.parse(Endpoints.issues));
    // request.fields['nim'] = nim; // Add other data fields
    request.fields['title_issues'] = title; // Add other data fields
    request.fields['description_issues'] = description; // Add other data fields
    request.fields['rating'] = rating; // Add other data fields
    // request.fields['division_target'] = _divisionTarget; // Add other data fields
    // request.fields['priority'] = _priority; // Add other data fields

    var multipartFile = await MultipartFile.fromPath(
      'image',
      galleryFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.pushReplacementNamed(context, '/customerService');
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
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
                    "Create Issues 🍀",
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
                                SizedBox(height: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        'Division Target:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: _selectedType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedType = newValue;
                                        });
                                      },
                                      items: _checkboxData.map((data) {
                                        return DropdownMenuItem<String>(
                                          value: data['type'],
                                          child: Text(data['type']),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Select Type',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                        hintText: "Title of Issues",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    // onChanged: (value) {
                                    //   // Update state on text change
                                    //   setState(() {
                                    //     _title =
                                    //         value; // Update the _title state variable
                                    //   });
                                    // },
                                  ),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.all(10),
                                //   decoration: BoxDecoration(
                                //       border: Border(
                                //           bottom: BorderSide(
                                //               color: Colors.grey.shade200))),
                                //   child: TextField(
                                //     controller: _nimController,
                                //     decoration: const InputDecoration(
                                //         hintText: "NIM",
                                //         hintStyle: TextStyle(color: Colors.grey),
                                //         border: InputBorder.none),
                                //   ),
                                // ),
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
                                // Container(
                                //   padding: const EdgeInsets.all(10),
                                //   decoration: BoxDecoration(
                                //       border: Border(
                                //           bottom: BorderSide(
                                //               color: Colors.grey.shade200))),
                                //   child: TextField(
                                //     controller: _ratingController,
                                //     decoration: const InputDecoration(
                                //         hintText: "rating",
                                //         hintStyle: TextStyle(color: Colors.grey),
                                //         border: InputBorder.none),
                                //   ),
                                // ),
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
                                        double.infinity, // Fill available space
                                    height: 150, // Adjust height as needed
                                    // color: Colors.grey[200], // Placeholder color
                                    child: galleryFile == null
                                        ? Center(
                                            child: Text('Pick your Image here',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                      255, 124, 122, 122),
                                                  fontWeight: FontWeight.w500,
                                                )))
                                        : Center(
                                            child: Image.file(galleryFile!),
                                          ), // Placeholder text
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _rating = index + 1;
                                          });
                                        },
                                        child: Icon(
                                          Icons.star,
                                          color: _rating >= index + 1
                                              ? Colors.amber
                                              : Colors.grey,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        'Select Priority:',
                                        style: TextStyle(
                                          // fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ToggleButtons(
                                        isSelected: [
                                          _priority == 'high',
                                          _priority == 'low'
                                        ],
                                        onPressed: (int newIndex) {
                                          setState(() {
                                            _priority =
                                                newIndex == 0 ? 'high' : 'low';
                                          });
                                        },
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderWidth: 2.0,
                                        borderColor: Colors.grey,
                                        selectedBorderColor: Colors
                                            .green, // Ganti dengan warna aksen hijau
                                        fillColor: Colors
                                            .green, // Ganti dengan warna aksen hijau
                                        selectedColor: Colors.white,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              'High',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              'Low',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                    ],
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
          _postDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
