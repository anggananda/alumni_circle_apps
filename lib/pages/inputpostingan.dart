import 'package:flutter/material.dart';
import 'package:my_app/models/postingan.dart';
import 'package:my_app/helpers/dbhelper.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({Key? key, required this.onSubmit, required this.dbHelper}) : super(key: key);
  final Function(String, String) onSubmit;
  final DatabaseHelper dbHelper;

  @override
  _AddPostFormState createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Postingan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: _selectDate,
              child: Text('Select Date: ${_selectedDate.toString().substring(0, 10)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Submit'),
        ),
      ],
    );
  }

  void _selectDate() async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    initialDatePickerMode: DatePickerMode.day, // Set the initial date picker mode to show only date
  );
  if (pickedDate != null && pickedDate != _selectedDate) {
    setState(() {
      _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day); // Hanya tanggal, bulan, dan tahun yang diambil
    });
  }
}


void _submit() {
  String title = _titleController.text.trim();
  String content = _contentController.text.trim();
  if (title.isNotEmpty && content.isNotEmpty) {
    widget.onSubmit(title, content);
    Navigator.of(context).pop();
  }
}

}
