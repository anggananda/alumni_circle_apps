import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/services/db_helper_alumni.dart';
import 'package:flutter/material.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> syncAlumni(int idAlumni, String accessToken) async {
  try {
    // Ambil data dari API
    final alumniFromApi = await DataService.fetchAlumni(idAlumni, accessToken);

    // Hapus data lama di SQLite
    await _dbHelper.deleteAllAlumni();

    // Simpan data baru ke SQLite
    for (var alumni in alumniFromApi) {
      await _dbHelper.insertAlumni(alumni);
    }

    debugPrint("Berhasil memasukkan data ke SQLite");
  } catch (e) {
    debugPrint("Error syncing alumni data: $e");
    // Tangani kesalahan lebih lanjut jika diperlukan, misalnya dengan menampilkan pesan ke pengguna
  }
}

}
