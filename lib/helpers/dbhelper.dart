import 'package:flutter/material.dart'; 
import 'package:my_app/models/posts.dart';
import 'package:sqflite/sqflite.dart'; 
import 'package:path/path.dart'; 

// Kelas DatabaseHelper untuk mengelola operasi database SQLite
class DatabaseHelper {
  // Singleton instance dari DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  // Factory constructor untuk mengembalikan instance DatabaseHelper
  factory DatabaseHelper() => _instance;

  // Database instance yang digunakan
  static Database? _db;

  // Getter untuk mendapatkan database instance
  Future<Database> get db async {
    if (_db != null) {
      return _db!; // Jika database sudah ada, kembalikan instance yang sudah ada
    }
    _db = await initDb(); // Jika tidak, inisialisasikan database baru
    return _db!; // Kembalikan instance database yang baru
  }

  // Konstruktor internal DatabaseHelper
  DatabaseHelper.internal();

  // Inisialisasi database
  Future<Database> initDb() async {
    // Dapatkan path untuk direktori database
    String databasesPath = await getDatabasesPath();
    // Gabungkan path untuk database dengan nama database
    String path = join(databasesPath, 'alumni_posts.db');

    // Buka atau buat database di path yang diberikan
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db; // Kembalikan instance database yang dibuka
  }

  // Method untuk membuat tabel saat database dibuat
  void _onCreate(Database db, int version) async {
    // Execute SQL untuk membuat tabel posts
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  // Method untuk menambahkan data post ke dalam database
  Future<int> addPost(Post post) async {
    var dbClient = await db; // Dapatkan instance database
    int res = await dbClient.insert('posts', post.toMap()); // Insert data post ke dalam tabel posts
    return res; // Kembalikan hasil operasi insert
  }

  // Method untuk mendapatkan semua data post dari database
  Future<List<Post>> getPosts() async {
    var dbClient = await db; // Dapatkan instance database
    List<Map<String, dynamic>> maps = await dbClient.query('posts'); // Query semua data dari tabel posts
    // Map hasil query menjadi list of Post objects
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // Method untuk mengupdate data post di dalam database
  Future<int> updatePost(Post post) async {
    var dbClient = await db; // Dapatkan instance database
    // Update data post di dalam tabel posts berdasarkan id
    return await dbClient.update('posts', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
  }

  // Method untuk menghapus data post dari database berdasarkan id
  Future<int> deletePost(int id) async {
    var dbClient = await db; // Dapatkan instance database
    // Hapus data post dari tabel posts berdasarkan id
    return await dbClient.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // Method untuk menutup koneksi database
  Future<void> close() async {
    try {
      var dbClient = await db; // Dapatkan instance database
      _db = null; // Set instance database menjadi null
      await dbClient.close(); // Tutup koneksi database
    } catch (error) {
      // Tangani kesalahan yang mungkin terjadi saat menutup koneksi database
      debugPrint('Error closing database: $error');
    }
  }
}
