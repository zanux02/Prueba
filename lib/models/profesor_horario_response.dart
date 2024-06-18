import 'dart:convert';

class ProfesorHorarioResponse {
  ProfesorHorarioResponse({
    required this.result,
  });

  List<ProfesorHorarioResult> result;

  factory ProfesorHorarioResponse.fromJson(String str) =>
      ProfesorHorarioResponse.fromMap(json.decode(str));

  factory ProfesorHorarioResponse.fromMap(Map<String, dynamic> json) => ProfesorHorarioResponse(
        result: List<ProfesorHorarioResult>.from(
            json["results"].map((x) => ProfesorHorarioResult.fromMap(x))),
      );
}

class ProfesorHorarioResult {
  ProfesorHorarioResult({
    required this.curso,
    required this.dia,
    required this.hora,
    required this.asignatura,
    required this.aulas,
    required this.nombreProfesor,
    required this.apellidoProfesor
  });

  String curso;
  String dia;
  String hora;
  String asignatura;
  String aulas;
  String nombreProfesor;
  String apellidoProfesor;

  factory ProfesorHorarioResult.fromJson(String str) =>
      ProfesorHorarioResult.fromMap(json.decode(str));

  factory ProfesorHorarioResult.fromMap(Map<String, dynamic> json) => ProfesorHorarioResult(
        curso: json["Curso"],
        dia: json["Dia"],
        hora: json["Hora"],
        asignatura: json["Asignatura"],
        aulas: json["Aulas"],
        nombreProfesor: json["NombreProfesor"],
        apellidoProfesor: json["ApellidoProfesor"]
      );
}
