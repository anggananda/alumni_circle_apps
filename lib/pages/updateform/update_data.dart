import 'dart:io';
import 'package:alumni_circle_app/dto/datas.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFormScreen extends StatefulWidget {
  final Datas data;
  const UpdateFormScreen({super.key, required this.data});

  @override
  State<UpdateFormScreen> createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  late TextEditingController _titleController;
  String? _preview;
  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data.name);
    _preview = widget.data.imageUrl;
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
          _imageFile = File(pickedFile!.path);
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
    if (_imageFile == null) {
      return; // Handle case where no image is selected
    }

    var request = MultipartRequest('POST', Uri.parse('${Endpoints.datas}/${widget.data.idDatas}'));
    request.fields['name'] = _titleController.text; // Add other data fields

    var multipartFile = await MultipartFile.fromPath(
      'image',
      _imageFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 200) {
        debugPrint('Data and image posted successfully!');
        Navigator.pushReplacementNamed(context, '/datas');
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
                    "Create datas",
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
                    "Fill the datas below, make sure you add titles and upload the images",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                            GestureDetector(
                              onTap: () {
                                _showPicker(context: context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                width: double.infinity, // Fill available space
                                height: 150, // Adjust height as needed
                                // color: Colors.grey[200], // Placeholder color
                                child: _imageFile == null
                                    ? Center(
                                        // child: Text('Pick your Image here',
                                        //     style: GoogleFonts.poppins(
                                        //       fontSize: 14,
                                        //       color: const Color.fromARGB(
                                        //           255, 124, 122, 122),
                                        //       fontWeight: FontWeight.w500,
                                        //     )))
                                        child: Image.network('${Endpoints.urlDatas}/public/${_preview!}'))
                                    : Center(
                                        child: Image.file(_imageFile!),
                                      ), // Placeholder text
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                    hintText: "Title of Image",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  // Update state on text change
                                  // setState(() {
                                  //   _title =
                                  //       value; // Update the _title state variable
                                  // });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ) 
                ),
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