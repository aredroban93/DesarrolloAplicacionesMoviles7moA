import 'package:flutter/material.dart';
import '../models/computer.dart';
import '../helpers/database_helper.dart';
import 'computer_form_screen.dart';

class ComputerListScreen extends StatefulWidget {
  const ComputerListScreen({super.key});

  @override
  State<ComputerListScreen> createState() => _ComputerListScreenState();
}

class _ComputerListScreenState extends State<ComputerListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Computer> _computers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComputers();
  }

  Future<void> _loadComputers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final computers = await _databaseHelper.getAllComputers();
      setState(() {
        _computers = computers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar computadoras: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteComputer(int id) async {
    try {
      await _databaseHelper.deleteComputer(id);
      await _loadComputers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Computadora eliminada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar computadora: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(Computer computer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar la computadora ${computer.marca} ${computer.tipo}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteComputer(computer.id!);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToForm([Computer? computer]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComputerFormScreen(computer: computer),
      ),
    );

    if (result == true) {
      await _loadComputers();
    }
  }

  Widget _buildComputerCard(Computer computer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: computer.tipo == 'Laptop'
              ? Colors.blue
              : Colors.green,
          child: Icon(
            computer.tipo == 'Laptop' ? Icons.laptop : Icons.desktop_windows,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${computer.marca} - ${computer.tipo}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('CPU: ${computer.cpu}'),
            Text('RAM: ${computer.ram}'),
            Text('HDD: ${computer.hdd}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _navigateToForm(computer);
            } else if (value == 'delete') {
              _showDeleteConfirmation(computer);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Computadoras'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _computers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.computer_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay computadoras registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toca el botón + para agregar una nueva',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadComputers,
              child: ListView.builder(
                itemCount: _computers.length,
                itemBuilder: (context, index) {
                  return _buildComputerCard(_computers[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Agregar computadora',
        child: const Icon(Icons.add),
      ),
    );
  }
}
