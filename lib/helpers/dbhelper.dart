import 'package:my_app/models/postingan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'alumni_posts.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> addPost(Post post) async {
    var dbClient = await db;
    int res = await dbClient.insert('posts', post.toMap());
    return res;
  }

  Future<List<Post>> getPosts() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('posts');
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  Future<int> updatePost(Post post) async {
    var dbClient = await db;
    return await dbClient.update('posts', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
  }

  Future<int> deletePost(int id) async {
    var dbClient = await db;
    return await dbClient.delete('posts', where: 'id = ?', whereArgs: [id]);
  }
}
