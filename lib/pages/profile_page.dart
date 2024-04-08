import 'package:flutter/material.dart';
import 'package:my_app/utils/menu_items.dart'; // Import daftar menuItems

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3, // Menentukan jumlah kolom dalam grid
      crossAxisSpacing: 30.0, // Jarak antar kolom
      mainAxisSpacing: 10.0, // Jarak antar baris
      padding: const EdgeInsets.all(10.0), // Padding untuk grid
      children: getMenuItems(context).map((item) {
        return ElevatedButton(
          onPressed: item.onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                primary: Colors.blue, // Warna latar belakang tombol
                onPrimary: Colors.white, // Warna teks pada tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bentuk tombol
                ),
              ),
              child: Text(
                item.title,
                style: TextStyle(fontSize: 16.0), // Gaya teks pada tombol
              ),
        );
      }).toList(),
    );
  }
}
