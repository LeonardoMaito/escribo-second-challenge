import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabase{

  static final BookDatabase instance = BookDatabase._init();
  static Database? _database;

  BookDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb('bookDb.db');
    return _database!;
  }

  Future<Database> initDb(String filePath) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bookDb.db');

     return await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
          newDb.execute("""
                  CREATE TABLE Books
                  (
                     id INTEGER PRIMARY KEY,
                     isFavorite INTEGER,
                     localPath TEXT
                  )
                """);
        });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}