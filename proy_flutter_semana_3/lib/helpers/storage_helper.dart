import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/computer.dart';

class StorageHelper {
  static const String _computersKey = 'computers';
  static const String _counterKey = 'computer_counter';

  static Future<List<Computer>> getAllComputers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final computersJson = prefs.getString(_computersKey);

      if (computersJson == null) {
        // Si no hay datos, cargar datos de ejemplo
        return await _loadSampleData();
      }

      final List<dynamic> computersList = json.decode(computersJson);
      return computersList.map((json) => Computer.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error cargando computadoras: $e');
      return await _loadSampleData();
    }
  }

  static Future<List<Computer>> _loadSampleData() async {
    final sampleComputers = [
      Computer(
        id: 1,
        tipo: 'Escritorio',
        marca: 'Lenovo',
        cpu: 'i7',
        ram: '16 GB',
        hdd: '1 TB',
      ),
      Computer(
        id: 2,
        tipo: 'Laptop',
        marca: 'Acer',
        cpu: 'i5',
        ram: '16GB',
        hdd: '500 GB',
      ),
      Computer(
        id: 3,
        tipo: 'Escritorio',
        marca: 'Asus',
        cpu: 'i7',
        ram: '32 GB',
        hdd: '1 TB',
      ),
      Computer(
        id: 4,
        tipo: 'Escritorio',
        marca: 'iMac',
        cpu: 'M4',
        ram: '32 GB',
        hdd: '2TB',
      ),
    ];

    await _saveComputers(sampleComputers);
    await _saveCounter(4);
    return sampleComputers;
  }

  static Future<void> _saveComputers(List<Computer> computers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final computersJson = json.encode(
        computers.map((c) => c.toMap()).toList(),
      );
      await prefs.setString(_computersKey, computersJson);
    } catch (e) {
      debugPrint('Error guardando computadoras: $e');
      throw Exception('Error guardando computadoras');
    }
  }

  static Future<int> _getNextId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCounter = prefs.getInt(_counterKey) ?? 4;
      final nextId = currentCounter + 1;
      await prefs.setInt(_counterKey, nextId);
      return nextId;
    } catch (e) {
      debugPrint('Error obteniendo siguiente ID: $e');
      return DateTime.now().millisecondsSinceEpoch;
    }
  }

  static Future<void> _saveCounter(int counter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_counterKey, counter);
    } catch (e) {
      debugPrint('Error guardando contador: $e');
    }
  }

  static Future<int> insertComputer(Computer computer) async {
    try {
      final computers = await getAllComputers();
      final newId = await _getNextId();
      final newComputer = computer.copyWith(id: newId);

      computers.add(newComputer);
      await _saveComputers(computers);

      return newId;
    } catch (e) {
      debugPrint('Error insertando computadora: $e');
      throw Exception('Error insertando computadora');
    }
  }

  static Future<Computer?> getComputer(int id) async {
    try {
      final computers = await getAllComputers();
      return computers.firstWhere(
        (computer) => computer.id == id,
        orElse: () => throw Exception('Computadora no encontrada'),
      );
    } catch (e) {
      debugPrint('Error obteniendo computadora: $e');
      return null;
    }
  }

  static Future<int> updateComputer(Computer computer) async {
    try {
      final computers = await getAllComputers();
      final index = computers.indexWhere((c) => c.id == computer.id);

      if (index == -1) {
        throw Exception('Computadora no encontrada');
      }

      computers[index] = computer;
      await _saveComputers(computers);

      return 1; // Número de filas afectadas
    } catch (e) {
      debugPrint('Error actualizando computadora: $e');
      throw Exception('Error actualizando computadora');
    }
  }

  static Future<int> deleteComputer(int id) async {
    try {
      final computers = await getAllComputers();
      final initialLength = computers.length;

      computers.removeWhere((computer) => computer.id == id);

      if (computers.length == initialLength) {
        throw Exception('Computadora no encontrada');
      }

      await _saveComputers(computers);

      return 1; // Número de filas afectadas
    } catch (e) {
      debugPrint('Error eliminando computadora: $e');
      throw Exception('Error eliminando computadora');
    }
  }

  static Future<int> getComputerCount() async {
    try {
      final computers = await getAllComputers();
      return computers.length;
    } catch (e) {
      debugPrint('Error obteniendo conteo: $e');
      return 0;
    }
  }
}
