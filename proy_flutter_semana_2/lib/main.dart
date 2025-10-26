import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Calificaciones UISRAEL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalificacionesPage(),
    );
  }
}

class CalificacionesPage extends StatefulWidget {
  const CalificacionesPage({super.key});

  @override
  State<CalificacionesPage> createState() => _CalificacionesPageState();
}

class _CalificacionesPageState extends State<CalificacionesPage> {
  // Lista de estudiantes predefinidos
  final List<String> _estudiantes = [
    'Juan Pérez',
    'María González',
    'Carlos López',
    'Ana Rodríguez',
    'Diego Martínez',
  ];

  // Variables para almacenar los datos del formulario
  String? _estudianteSeleccionado;
  DateTime? _fechaSeleccionada;

  // Controladores para los campos de texto
  final _seguimiento1Controller = TextEditingController();
  final _examen1Controller = TextEditingController();
  final _seguimiento2Controller = TextEditingController();
  final _examen2Controller = TextEditingController();

  @override
  void dispose() {
    _seguimiento1Controller.dispose();
    _examen1Controller.dispose();
    _seguimiento2Controller.dispose();
    _examen2Controller.dispose();
    super.dispose();
  }

  // Función para validar que el valor esté entre 0 y 10
  bool _validarNota(String valor) {
    if (valor.isEmpty) return false;
    final nota = double.tryParse(valor);
    return nota != null && nota >= 0 && nota <= 10;
  }

  // Función para calcular las notas y mostrar el resultado
  void _calcularCalificaciones() {
    // Validar que todos los campos estén llenos
    if (_estudianteSeleccionado == null) {
      _mostrarError('Por favor selecciona un estudiante');
      return;
    }

    if (_fechaSeleccionada == null) {
      _mostrarError('Por favor selecciona una fecha');
      return;
    }

    if (!_validarNota(_seguimiento1Controller.text)) {
      _mostrarError('La nota de Seguimiento 1 debe estar entre 0 y 10');
      return;
    }

    if (!_validarNota(_examen1Controller.text)) {
      _mostrarError('La nota de Examen 1 debe estar entre 0 y 10');
      return;
    }

    if (!_validarNota(_seguimiento2Controller.text)) {
      _mostrarError('La nota de Seguimiento 2 debe estar entre 0 y 10');
      return;
    }

    if (!_validarNota(_examen2Controller.text)) {
      _mostrarError('La nota de Examen 2 debe estar entre 0 y 10');
      return;
    }

    // Calcular las notas
    final seguimiento1 = double.parse(_seguimiento1Controller.text);
    final examen1 = double.parse(_examen1Controller.text);
    final seguimiento2 = double.parse(_seguimiento2Controller.text);
    final examen2 = double.parse(_examen2Controller.text);

    // Calcular notas parciales
    final notaParcial1 = (seguimiento1 * 0.3) + (examen1 * 0.2);
    final notaParcial2 = (seguimiento2 * 0.3) + (examen2 * 0.2);
    final notaFinal = notaParcial1 + notaParcial2;

    // Determinar el estado
    String estado;
    if (notaFinal >= 7) {
      estado = 'APROBADO';
    } else if (notaFinal >= 5 && notaFinal <= 6.9) {
      estado = 'COMPLEMENTARIO';
    } else {
      estado = 'REPROBADO';
    }

    // Mostrar el resultado en un Alert Dialog
    _mostrarResultado(notaParcial1, notaParcial2, notaFinal, estado);
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarResultado(
    double notaParcial1,
    double notaParcial2,
    double notaFinal,
    String estado,
  ) {
    final fechaFormateada =
        '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado de Calificaciones'),
          content: Text(
            'Nombre: $_estudianteSeleccionado\n'
            'Fecha: $fechaFormateada\n'
            'Nota Parcial 1: ${notaParcial1.toStringAsFixed(2)}\n'
            'Nota Parcial 2: ${notaParcial2.toStringAsFixed(2)}\n'
            'Nota Final: ${notaFinal.toStringAsFixed(2)}\n'
            'Estado: $estado',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Calificaciones UISRAEL'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selector de estudiante
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nombre del Estudiante:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _estudianteSeleccionado,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecciona un estudiante',
                      ),
                      items: _estudiantes.map((String estudiante) {
                        return DropdownMenuItem<String>(
                          value: estudiante,
                          child: Text(estudiante),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _estudianteSeleccionado = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Selector de fecha
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _seleccionarFecha,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fechaSeleccionada == null
                                  ? 'Seleccionar fecha'
                                  : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Primer parcial
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRIMER PARCIAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _seguimiento1Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nota Seguimiento 1 (sobre 10) * 0.3',
                        border: OutlineInputBorder(),
                        hintText: '0.0 - 10.0',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _examen1Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Examen 1 (sobre 10) * 0.2',
                        border: OutlineInputBorder(),
                        hintText: '0.0 - 10.0',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Segundo parcial
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SEGUNDO PARCIAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _seguimiento2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nota Seguimiento 2 (sobre 10) * 0.3',
                        border: OutlineInputBorder(),
                        hintText: '0.0 - 10.0',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _examen2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Examen 2 (sobre 10) * 0.2',
                        border: OutlineInputBorder(),
                        hintText: '0.0 - 10.0',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botón para calcular
            ElevatedButton(
              onPressed: _calcularCalificaciones,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'CALCULAR CALIFICACIONES',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            // Información adicional
            Card(
              color: Colors.grey[100],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Criterios de Evaluación:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Nota Final ≥ 7.0: APROBADO'),
                    Text('• Nota Final 5.0 - 6.9: COMPLEMENTARIO'),
                    Text('• Nota Final < 5.0: REPROBADO'),
                    SizedBox(height: 8),
                    Text(
                      'Fórmula de Cálculo:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '• Parcial 1 = (Seguimiento1 × 0.3) + (Examen1 × 0.2)',
                    ),
                    Text(
                      '• Parcial 2 = (Seguimiento2 × 0.3) + (Examen2 × 0.2)',
                    ),
                    Text('• Nota Final = Parcial 1 + Parcial 2'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
