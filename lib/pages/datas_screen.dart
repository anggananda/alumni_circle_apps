import 'dart:io';

import 'package:alumni_circle_app/dto/datas.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/updateform/update_data.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
// import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DatasScreen extends StatefulWidget {
  const DatasScreen({super.key});

  @override
  State<DatasScreen> createState() => _DatasScreenState();
}

class _DatasScreenState extends State<DatasScreen> {
  Future<List<Datas>>? _datas;

  @override
  void initState() {
    super.initState();
    _datas = DataService.fetchDatas();
  }

  Future<XFile?> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(source: source);
    } catch (e) {
      print('Error picking image: $e');
    }

    return pickedFile;
  }

  void _updateDatas(Datas datas) async {
    TextEditingController nameController =
        TextEditingController(text: datas.name);

    XFile? pickedImage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Datas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Button to choose image
                ElevatedButton(
                  onPressed: () async {
                    pickedImage = await _getImage(ImageSource.gallery);
                    if (pickedImage != null) {
                      // Handle selected image
                    }
                  },
                  child: Text('Choose Image from Gallery'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    pickedImage = await _getImage(ImageSource.camera);
                    if (pickedImage != null) {
                      // Handle selected image
                    }
                  },
                  child: Text('Take Picture'),
                ),
                // Add other form fields for other data
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await DataService.updateDatas(
                      datas.name, File(pickedImage!.path), datas.idDatas);
                  // Handle success
                  print('Data updated successfully!');
                  // Refresh data list or do other actions
                } catch (error) {
                  print('Error updating data: $error');
                  // Handle error
                }
              },
              child: Text(
                'Update',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // Delete Datas
  void _deleteDatas(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text("Apakah Anda yakin ingin menghapus data?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    true); // Setelah tombol "OK" ditekan, nilai dialog adalah true
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    false); // Setelah tombol "Batal" ditekan, nilai dialog adalah false
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == null || !confirmDelete) {
      return;
    }

    try {
      await DataService.deleteDatas(id);
      List<Datas> updatedNews = await DataService.fetchDatas();
      setState(() {
        _datas = Future.value(updatedNews);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Text(
              'Deleted datas successfully.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Failed to delete news: $error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Text(
              'Failed to delete datas $error',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Datas'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: FutureBuilder<List<Datas>>(
          future: _datas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final post = data[index];
                  return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          // color: thirdColor
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Warna bayangan
                              spreadRadius: 2, // Jarak bayangan dari objek
                              blurRadius: 5, // Besarnya "blur" pada bayangan
                              offset: Offset(0,
                                  3), // Posisi bayangan relatif terhadap objek
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      Uri.parse(
                                              '${Endpoints.urlDatas}/public/${post.imageUrl!}')
                                          .toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(post.name),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            _deleteDatas(post.idDatas),
                                        child: Icon(
                                          Icons.delete,
                                          color: primaryFontColor,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateFormScreen(data: post),
                                            ),
                                          )
                                        },
                                        // _updateDatas(post),
                                        child: Icon(
                                          Icons.edit,
                                          color: primaryFontColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // Show a loading indicator while waiting for data
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, '/postdatas')},
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}
