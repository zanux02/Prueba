class Profesor {
  final String nombre;
  final String primerApellido;
  final String segundoApellido;

  Profesor({
    required this.nombre,
    String? primerApellido,
    String? segundoApellido,
  })  : primerApellido = primerApellido ?? '',
        segundoApellido = segundoApellido ?? '';

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      nombre: json['nombre'],
      primerApellido: json['primerApellido'] ?? '',
      segundoApellido: json['segundoApellido'] ?? '',
    );
  }
}