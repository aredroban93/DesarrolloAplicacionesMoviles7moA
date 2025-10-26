import 'package:flutter/material.dart';
import '../models/computer.dart';
import '../helpers/database_helper.dart';

class ComputerFormScreen extends StatefulWidget {
  final Computer? computer;

  const ComputerFormScreen({super.key, this.computer});

  @override
  State<ComputerFormScreen> createState() => _ComputerFormScreenState();
}

class _ComputerFormScreenState extends State<ComputerFormScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tipoController;
  late TextEditingController _marcaController;
  late TextEditingController _cpuController;
  late TextEditingController _ramController;
  late TextEditingController _hddController;

  bool _isLoading = false;
  String? _selectedTipo;

  final List<String> _tiposDisponibles = ['Escritorio', 'Laptop'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tipoController = TextEditingController(text: widget.computer?.tipo ?? '');
    _marcaController = TextEditingController(
      text: widget.computer?.marca ?? '',
    );
    _cpuController = TextEditingController(text: widget.computer?.cpu ?? '');
    _ramController = TextEditingController(text: widget.computer?.ram ?? '');
    _hddController = TextEditingController(text: widget.computer?.hdd ?? '');

    _selectedTipo = widget.computer?.tipo;
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _marcaController.dispose();
    _cpuController.dispose();
    _ramController.dispose();
    _hddController.dispose();
    super.dispose();
  }

  Future<void> _saveComputer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final computer = Computer(
        id: widget.computer?.id,
        tipo: _selectedTipo!,
        marca: _marcaController.text.trim(),
        cpu: _cpuController.text.trim(),
        ram: _ramController.text.trim(),
        hdd: _hddController.text.trim(),
      );

      if (widget.computer == null) {
        // Crear nueva computadora
        await _databaseHelper.insertComputer(computer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Computadora agregada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar computadora existente
        await _databaseHelper.updateComputer(computer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Computadora actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar computadora: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.computer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Computadora' : 'Nueva Computadora'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isEditing)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Editando computadora ID: ${widget.computer!.id}',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (isEditing) const SizedBox(height: 20),

                    _buildDropdownField(
                      label: 'Tipo',
                      value: _selectedTipo,
                      items: _tiposDisponibles,
                      onChanged: (value) {
                        setState(() {
                          _selectedTipo = value;
                          _tipoController.text = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un tipo';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _marcaController,
                      label: 'Marca',
                      icon: Icons.business,
                      hint: 'Ej: Lenovo, Dell, HP, Apple',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la marca';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _cpuController,
                      label: 'CPU',
                      icon: Icons.memory,
                      hint: 'Ej: i7, i5, M4, Ryzen 7',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa el CPU';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _ramController,
                      label: 'RAM',
                      icon: Icons.storage,
                      hint: 'Ej: 16 GB, 32 GB, 8GB',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la cantidad de RAM';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _hddController,
                      label: 'Disco Duro (HDD/SSD)',
                      icon: Icons.save,
                      hint: 'Ej: 1 TB, 500 GB, 2TB',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la capacidad del disco';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveComputer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEditing
                            ? 'Actualizar Computadora'
                            : 'Guardar Computadora',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
