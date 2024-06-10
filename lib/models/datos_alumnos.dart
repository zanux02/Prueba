class DatosAlumnos {
  final String nombre;
  final String curso;

  DatosAlumnos({required this.nombre, required this.curso});

  factory DatosAlumnos.fromJson(Map<String, dynamic> json) {
    return DatosAlumnos(
      nombre: json['name'] ?? 'Nombre desconocido',
      curso: json['course'] ?? 'Curso desconocido',
    );
  }
}
