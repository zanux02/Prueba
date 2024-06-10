class ProfesorContacto {
  final String nombre;
  final String primerApellido;
  final String segundoApellido;
  final String correo;
  final String? telefono;

  ProfesorContacto({
    required this.nombre,
    required this.primerApellido,
    required this.segundoApellido,
    required this.correo,
    this.telefono,
  });

  factory ProfesorContacto.fromJson(Map<String, dynamic> json) {
    return ProfesorContacto(
      nombre: json['nombre'] ?? '',
      primerApellido: json['primerApellido'] ?? '',
      segundoApellido: json['segundoApellido'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'],
    );
  }
}
