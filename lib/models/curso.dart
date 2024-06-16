class Curso {
  final String nombre;
  final List<Estudiante> estudiantes;

  Curso({required this.nombre, required this.estudiantes});

  factory Curso.fromJson(Map<String, dynamic> json) {
    var estudiantesJson = json['estudiantes'] as List;
    List<Estudiante> estudiantesList = estudiantesJson.map((i) => Estudiante.fromJson(i)).toList();

    return Curso(
      nombre: json['nombre'],
      estudiantes: estudiantesList,
    );
  }
}

class Estudiante {
  final String nombre;
  final String primerApellido;
  final String segundoApellido;

  Estudiante({required this.nombre, required this.primerApellido, required this.segundoApellido});

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      nombre: json['nombre'],
      primerApellido: json['primerApellido'],
      segundoApellido: json['segundoApellido'],
    );
  }
}
