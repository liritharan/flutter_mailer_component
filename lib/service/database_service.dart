import 'package:flutter_email_component/model/database_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService() => _databaseService;

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE record(id INTEGER PRIMARY KEY, transDes TEXT, transStatus TEXT,date TEXT)',
    );
    // Run the CREATE {dogs} TABLE statement on the database.
    print('created');
  }

  // Define a function that inserts breeds into the database
  Future<void> insertRecord(DatabaseModel record) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    await db.insert(
      'record',
      record.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    print('inserted');
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<DatabaseModel>> getRecord() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('record');

    // Convert the List<Map<String, dynamic> into a List<Breed>.

    return List.generate(
        maps.length, (index) => DatabaseModel.fromJson(maps[index]));
  }

  Future<List<DatabaseModel>> getError(String transStatus) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db
        .query('record', where: 'transStatus = ?', whereArgs: [transStatus]);
    return List.generate(
        maps.length, (index) => DatabaseModel.fromJson(maps[index]));
  }
}
