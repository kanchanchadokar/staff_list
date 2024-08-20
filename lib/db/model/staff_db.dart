import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:staff_data/db/model/staff_model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'staff.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE staff(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        number TEXT,
        position TEXT
      )
    ''');
  }

  Future<int> insertEmployee(StaffModel mStaffModel) async {
    Database db = await database;
    return await db.insert('staff', mStaffModel.toMap());
  }

  Future<List<StaffModel>> getEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('staff');
    return maps.map((map) => StaffModel.fromMap(map)).toList();
  }

  Future<int> updateEmployee(StaffModel mStaffModel) async {
    Database db = await database;
    return await db.update(
      'staff',
      mStaffModel.toMap(),
      where: 'id = ?',
      whereArgs: [mStaffModel.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    Database db = await database;
    return await db.delete(
      'staff',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> searchItemsByName(String name) async {
    final db = await database;
    return await db.query(
      'staff',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
  }
}
