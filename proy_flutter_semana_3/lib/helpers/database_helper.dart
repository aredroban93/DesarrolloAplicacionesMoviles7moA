import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/computer.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Método para inicializar la base de datos explícitamente
  static Future<void> initialize() async {
    if (_database == null) {
      final instance = DatabaseHelper();
      await instance.database;
    }
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'computers.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      throw Exception('Error inicializando base de datos: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE computers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        marca TEXT NOT NULL,
        cpu TEXT NOT NULL,
        ram TEXT NOT NULL,
        hdd TEXT NOT NULL
      )
    ''');

    // Insertar datos de ejemplo
    await db.insert('computers', {
      'tipo': 'Escritorio',
      'marca': 'Lenovo',
      'cpu': 'i7',
      'ram': '16 GB',
      'hdd': '1 TB',
    });

    await db.insert('computers', {
      'tipo': 'Laptop',
      'marca': 'Acer',
      'cpu': 'i5',
      'ram': '16GB',
      'hdd': '500 GB',
    });

    await db.insert('computers', {
      'tipo': 'Escritorio',
      'marca': 'Asus',
      'cpu': 'i7',
      'ram': '32 GB',
      'hdd': '1 TB',
    });

    await db.insert('computers', {
      'tipo': 'Escritorio',
      'marca': 'iMac',
      'cpu': 'M4',
      'ram': '32 GB',
      'hdd': '2TB',
    });
  }

  // CREATE - Insertar nueva computadora
  Future<int> insertComputer(Computer computer) async {
    final db = await database;
    return await db.insert('computers', computer.toMap());
  }

  // READ - Obtener todas las computadoras
  Future<List<Computer>> getAllComputers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('computers');
    return List.generate(maps.length, (i) {
      return Computer.fromMap(maps[i]);
    });
  }

  // READ - Obtener computadora por ID
  Future<Computer?> getComputer(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'computers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Computer.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE - Actualizar computadora
  Future<int> updateComputer(Computer computer) async {
    final db = await database;
    return await db.update(
      'computers',
      computer.toMap(),
      where: 'id = ?',
      whereArgs: [computer.id],
    );
  }

  // DELETE - Eliminar computadora
  Future<int> deleteComputer(int id) async {
    final db = await database;
    return await db.delete('computers', where: 'id = ?', whereArgs: [id]);
  }

  // UTILIDAD - Obtener conteo de computadoras
  Future<int> getComputerCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM computers');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // UTILIDAD - Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
