import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _complaint = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Center"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
  padding: EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            "Pusat Bantuan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryFontColor,
            ),
          ),
          subtitle: Text(
            "Silakan berikan informasi tentang masalah atau pertanyaan Anda. Kami siap membantu!",
            style: TextStyle(
              fontSize: 14,
              color: primaryFontColor,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      SizedBox(height: 20),
      Form(
  key: _formKey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Nama',
          hintText: 'Masukkan nama Anda',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Mohon masukkan nama Anda';
          }
          return null;
        },
        onSaved: (value) {
          _name = value!;
        },
      ),
      SizedBox(height: 10),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Masukkan alamat email Anda',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Mohon masukkan alamat email Anda';
          } else if (!value.contains('@')) {
            return 'Alamat email tidak valid';
          }
          return null;
        },
        onSaved: (value) {
          _email = value!;
        },
      ),
      SizedBox(height: 10),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Keluhan/Pertanyaan',
          hintText: 'Tuliskan keluhan atau pertanyaan Anda',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        maxLines: 5,
        validator: (value) {
          // Validasi opsional
          return null;
        },
        onSaved: (value) {
          _complaint = value!;
        },
      ),
      SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Lakukan sesuatu dengan data yang disimpan
              print('Submitted Name: $_name');
              print('Submitted Email: $_email');
              print('Submitted Complaint: $_complaint');
            }
          },
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  ),
),
    ],
  ),
),
      )  
    );
  }
}
