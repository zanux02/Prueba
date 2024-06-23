import 'dart:convert';

class ServicioResponse {
  ServicioResponse({
    required this.result,
  });

  List<Servicio> result;

  factory ServicioResponse.fromJson(String str) =>
      ServicioResponse.fromMap(json.decode(str));

  factory ServicioResponse.fromMap(Map<String, dynamic> json) {
    List<Servicio> serviciosList = [];

    if (json.containsKey("results")) {
      serviciosList = List<Servicio>.from(
          json["results"].map((x) => Servicio.fromJson(x)));
    }
    return ServicioResponse(
      result: serviciosList,
    );
  }
}


class Servicio {
  Servicio({
    required this.nombreAlumno,
    required this.fechaEntrada,
    required this.horaEntrada,
    required this.fechaSalida,
    required this.horaSalida,
  });

  String nombreAlumno;
  String fechaEntrada;
  String horaEntrada;
  String fechaSalida;
  String horaSalida;

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
        nombreAlumno: json[" "] ?? "",
        fechaEntrada: json["FechaEntrada"] ?? "",
        horaEntrada: json["HoraEntrada"] ?? "",
        fechaSalida: json["FechaSalida"] ?? "",
        horaSalida: json["HoraSalida"] ?? "",
      );
}

