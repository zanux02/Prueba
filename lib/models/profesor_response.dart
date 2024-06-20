// To parse this JSON data, do
//
//     final alumnos = alumnosFromMap(jsonString);

import 'dart:convert';

class ProfesorResponse {
  ProfesorResponse({
    required this.result,
  });

  List<ProfesorRes> result;

  factory ProfesorResponse.fromJson(String str) =>
      ProfesorResponse.fromMap(json.decode(str));

  factory ProfesorResponse.fromMap(Map<String, dynamic> json) => ProfesorResponse(
        result: List<ProfesorRes>.from(
            json["results"].map((x) => ProfesorRes.fromMap(x))),
      );
}
class ProfesorRes {
  String id;
  String usuario;
  String rol;
  String nombre;
  String apellidos;
  String telefono;

  ProfesorRes({
    required this.id,
    required this.usuario,
    required this.rol,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
  });

  factory ProfesorRes.fromMap(Map<String, dynamic> json) {
    return ProfesorRes(
      id: json['ID'],
      usuario: json['Usuario'],
      rol: json['Rol'],
      nombre: json['Nombre'],
      apellidos: json['Apellidos'],
      telefono: json['Teléfono'],
    );
  }
}

