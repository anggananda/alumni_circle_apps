import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'alumni.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE alumni(
            id_alumni INTEGER PRIMARY KEY,
            nama_alumni TEXT,
            jenis_kelamin TEXT,
            alamat TEXT,
            email TEXT,
            tanggal_lulus TEXT,
            angkatan TEXT,
            status_pekerjaan TEXT,
            username TEXT,
            password TEXT,
            roles TEXT,
            foto_profile TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertAlumni(Alumni alumni) async {
    final db = await database;
    await db.insert(
      'alumni',
      alumni.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Alumni>> getAllAlumni() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alumni');
    return List.generate(maps.length, (i) {
      return Alumni.fromMap(maps[i]);
    });
  }


  Future<void> deleteAllAlumni() async {
    final db = await database;
    await db.delete('alumni');
  }
}
