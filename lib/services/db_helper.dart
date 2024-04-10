import 'package:flutter/foundation.dart';
import 'package:my_app/dto/books.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _db;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get db async {
    _db ??= await initDatabase();
    return _db!; // Use the already initialized _db
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'db_books.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT)');
  }

  Future<Books> add(Books books) async {
    var dbClient = await db;
    books.id = await dbClient.insert('books', books.toMap());
    return books;
  }

  Future<List<Books>> getBooks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query('books', orderBy: 'id DESC');
    List<Books> books = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Books.fromMap(maps[i]));
      }
    }
    return books;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Books books) async {
    var dbClient = await db;
    return await dbClient.update(
      'books',
      books.toMap(),
      where: 'id = ?',
      whereArgs: [books.id],
    );
  }

  Future<void> close() async {
    try {
      // Access database client
      var dbClient = await db;
      _db = null;
      await dbClient.close();
    } catch (error) {
      // Handle potential errors during closure
      debugPrint('Error closing database: $error');
    }
  }
}