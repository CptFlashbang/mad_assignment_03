import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
  final getDirectory = await getApplicationDocumentsDirectory();
  String path = getDirectory.path + '/movies.db';
  log(path);
  return await openDatabase(path, onCreate: _onCreate, version: 1);
}
}
