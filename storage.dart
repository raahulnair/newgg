import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Storage {
  static Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'settings.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE preferences(fishCount INTEGER, fishColor INTEGER, fishSpeed REAL)',
        );
      },
      version: 1,
    );
  }

  static Future<void> savePreferences(int fishCount, int fishColor, double fishSpeed) async {
    final db = await _initDB();
    await db.insert('preferences', {
      'fishCount': fishCount,
      'fishColor': fishColor,
      'fishSpeed': fishSpeed,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> loadPreferences() async {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.query('preferences');

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
