import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'attractionModel.dart';
class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = getDirectory.path + '/attractions.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }
  void _onCreate(Database db, int version) async {
    await db.execute(
    'CREATE TABLE Attractions(id TEXT PRIMARY KEY, name TEXT, saved BOOL)');
    log('TABLE CREATED');
  }
  Future<List<AttractionModel>> getAttractions() async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Attractions');
    List<AttractionModel> attractions =
    List.generate(data.length, (index) => AttractionModel.fromJson(data[index]));
    print(attractions.length);
    return attractions;
  }
  Future<void> insertMovie(AttractionModel attraction) async {
    final db = await _databaseService.database;
    var data = await db.rawInsert(
        'INSERT INTO Attractions(id, name, saved, year ) VALUES(?,?,?,?)',
        [attraction.id, attraction.name, attraction.saved]);
    log('inserted $data');
  }
  // Future<void> editMovie(AttractionModel attraction) async {
  //   final db = await _databaseService.database;
  //   var data = await db.rawUpdate(
  //       'UPDATE Attractions SET name=?,saved=?,year=? WHERE ID=?',
  //       [attraction.name, attraction.saved, attraction.id]);
  //   log('updated $data');
  // }
  Future<void> deleteMovie(String id) async {
    final db = await _databaseService.database;
    var data = await db.rawDelete('DELETE from Attractions WHERE id=?', [id]);
    log('deleted $data');
  }
}