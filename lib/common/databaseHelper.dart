import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      return await _initDatabase();
    }
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ciap.db");
    print(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('create register table 1');

    await db.execute('''
          CREATE TABLE register (
            assttype  TEXT,
            company  TEXT,
            email  TEXT,
            pin  TEXT,
            status TEXT,
            firstname TEXT,
            lastname TEXT,
            middlename TEXT,
            username TEXT,
            password TEXT
          )
          ''');

    print('create register table 2');
  }
}
