import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static void showPicker({
    required BuildContext context,
    required Function(File?) onImagePicked,
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
                  getImage(context, ImageSource.gallery, onImagePicked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(context, ImageSource.camera, onImagePicked);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> getImage(
    BuildContext context,
    ImageSource source,
    Function(File?) onImagePicked,
  ) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      onImagePicked(file);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
      onImagePicked(null);
    }
    Navigator.of(context).pop();
  }
}
