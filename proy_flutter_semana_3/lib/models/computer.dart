class Computer {
  int? id;
  String tipo;
  String marca;
  String cpu;
  String ram;
  String hdd;

  Computer({
    this.id,
    required this.tipo,
    required this.marca,
    required this.cpu,
    required this.ram,
    required this.hdd,
  });

  // Convertir Computer a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'marca': marca,
      'cpu': cpu,
      'ram': ram,
      'hdd': hdd,
    };
  }

  // Crear Computer desde Map de SQLite
  factory Computer.fromMap(Map<String, dynamic> map) {
    return Computer(
      id: map['id']?.toInt(),
      tipo: map['tipo'] ?? '',
      marca: map['marca'] ?? '',
      cpu: map['cpu'] ?? '',
      ram: map['ram'] ?? '',
      hdd: map['hdd'] ?? '',
    );
  }

  // Método toString para debug
  @override
  String toString() {
    return 'Computer{id: $id, tipo: $tipo, marca: $marca, cpu: $cpu, ram: $ram, hdd: $hdd}';
  }

  // Método copyWith para ediciones
  Computer copyWith({
    int? id,
    String? tipo,
    String? marca,
    String? cpu,
    String? ram,
    String? hdd,
  }) {
    return Computer(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      marca: marca ?? this.marca,
      cpu: cpu ?? this.cpu,
      ram: ram ?? this.ram,
      hdd: hdd ?? this.hdd,
    );
  }
}
