import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/angga.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Software Developer',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue),
              title: Text(
                '+1234567890',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text(
                'john.doe@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text(
                'New York, USA',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.date_range, color: Colors.blue),
              title: Text(
                'Graduate Date: May 10, 2022',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.batch_prediction, color: Colors.blue),
              title: Text(
                'Batch: 2022',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan fungsi untuk mengedit profil
              },
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // warna latar belakang tombol
                onPrimary: primaryFontColor, // warna teks di atas tombol
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // atur border radius di sini
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), // atur padding tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
