import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NextSchoolDatabase {
  static final NextSchoolDatabase instance = NextSchoolDatabase._init();

  static Database? _database;

  NextSchoolDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('nextschool.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
  }

  Future close() async {
    final db = await instance.database;

    db.close(); 
  }

}
