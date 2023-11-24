
import 'package:sqflite/sqflite.dart';
import 'book_database.dart';

class BookDatabaseRepository {
  final BookDatabase _bookDatabase = BookDatabase.instance;

  Future<Map<int, bool>> getFavoriteStatuses() async {
    final db = await _bookDatabase.database;
    final result = await db.query('Books', columns: ['id', 'isFavorite']);

    Map<int, bool> favoriteStatuses = {};
    for (var row in result) {
      int id = row['id'] as int;
      bool isFavorite = row['isFavorite'] == 1;
      favoriteStatuses[id] = isFavorite;
    }

    return favoriteStatuses;
  }

  Future<void> toggleFavorite(int bookId, bool isFavorite) async {
    final db = await _bookDatabase.database;
    await db.update(
      'Books',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  Future<String?> getLocalPath(int bookId) async {
    final db = await _bookDatabase.database;
    final result = await db.query(
      'Books',
      columns: ['localPath'],
      where: 'id = ?',
      whereArgs: [bookId],
    );

    if (result.isNotEmpty) {
      return result.first['localPath'] as String?;
    }
    return null;
  }

  Future<void> saveBookPath(int bookId, String path) async {
    final db = await _bookDatabase.database;
    await db.insert(
      'Books',
      {'id': bookId, 'localPath': path, 'isFavorite': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
