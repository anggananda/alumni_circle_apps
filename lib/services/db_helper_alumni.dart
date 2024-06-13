import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlumniDatabase {
  static const String dbName = 'alumni.db';
  static const String alumniTable = 'alumni';
  static const String colId = 'id';
  static const String colNama = 'nama_alumni';
  static const String colJenisKelamin = 'jenis_kelamin';
  static const String colAlamat = 'alamat';
  static const String colEmail = 'email';
  static const String colTanggalLulus = 'tanggal_lulus';
  static const String colAngkatan = 'angkatan';
  static const String colStatusPekerjaan = 'status_pekerjaan';
  static const String colUsername = 'username';
  static const String colPassword = 'password';
  static const String colRoles = 'roles';
  static const String colFotoProfile = 'foto_profile';

  static Database? _database;
  static AlumniDatabase? _alumniDatabase;

  AlumniDatabase._privateConstructor();
  
  factory AlumniDatabase() {
    if (_alumniDatabase == null) {
      _alumniDatabase = AlumniDatabase._privateConstructor();
    }
    return _alumniDatabase!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $alumniTable (
        $colId INTEGER PRIMARY KEY,
        $colNama TEXT,
        $colJenisKelamin TEXT,
        $colAlamat TEXT,
        $colEmail TEXT,
        $colTanggalLulus TEXT,
        $colAngkatan TEXT,
        $colStatusPekerjaan TEXT,
        $colUsername TEXT,
        $colPassword TEXT,
        $colRoles TEXT,
        $colFotoProfile TEXT
      )
    ''');
  }

  Future<int> insertAlumni(Alumni alumni) async {
    Database db = await database;
    return await db.insert(alumniTable, alumni.toMap());
  }

  Future<List<Alumni>> getAlumni() async {
    Database db = await database;
    List<Map<String, dynamic>> alumniMapList = await db.query(alumniTable);
    return List.generate(alumniMapList.length, (index) {
      return Alumni.fromMap(alumniMapList[index]);
    });
  }

  Future<int> updateAlumni(Alumni alumni) async {
    Database db = await database;
    return await db.update(
      alumniTable,
      alumni.toMap(),
      where: '$colId = ?',
      whereArgs: [alumni.id],
    );
  }

  Future<int> deleteAlumni(int id) async {
    Database db = await database;
    return await db.delete(
      alumniTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}

class Alumni {
  final int id;
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final String email;
  final String tanggalLulus;
  final String angkatan;
  final String statusPekerjaan;
  final String username;
  final String password;
  final String roles;
  final String fotoProfile;

  Alumni({
    required this.id,
    required this.nama,
    required this.jenisKelamin,
    required this.alamat,
    required this.email,
    required this.tanggalLulus,
    required this.angkatan,
    required this.statusPekerjaan,
    required this.username,
    required this.password,
    required this.roles,
    required this.fotoProfile,
  });

  Map<String, dynamic> toMap() {
    return {
      AlumniDatabase.colId: id,
      AlumniDatabase.colNama: nama,
      AlumniDatabase.colJenisKelamin: jenisKelamin,
      AlumniDatabase.colAlamat: alamat,
      AlumniDatabase.colEmail: email,
      AlumniDatabase.colTanggalLulus: tanggalLulus,
      AlumniDatabase.colAngkatan: angkatan,
      AlumniDatabase.colStatusPekerjaan: statusPekerjaan,
      AlumniDatabase.colUsername: username,
      AlumniDatabase.colPassword: password,
      AlumniDatabase.colRoles: roles,
      AlumniDatabase.colFotoProfile: fotoProfile,
    };
  }

  factory Alumni.fromMap(Map<String, dynamic> map) {
    return Alumni(
      id: map[AlumniDatabase.colId],
      nama: map[AlumniDatabase.colNama],
      jenisKelamin: map[AlumniDatabase.colJenisKelamin],
      alamat: map[AlumniDatabase.colAlamat],
      email: map[AlumniDatabase.colEmail],
      tanggalLulus: map[AlumniDatabase.colTanggalLulus],
      angkatan: map[AlumniDatabase.colAngkatan],
      statusPekerjaan: map[AlumniDatabase.colStatusPekerjaan],
      username: map[AlumniDatabase.colUsername],
      password: map[AlumniDatabase.colPassword],
      roles: map[AlumniDatabase.colRoles],
      fotoProfile: map[AlumniDatabase.colFotoProfile],
    );
  }
}
