import 'package:flutter/material.dart';
import 'package:iJandula/models/models.dart';
import 'package:iJandula/utils/utilidades.dart';
import 'package:iJandula/utils/google_sheets.dart';

class AlumnadoProvider extends ChangeNotifier {
  List<DatosAlumnos> listadoAlumnos = [];
  List<HorarioResult> listadoHorarios = [];

  AlumnadoProvider() {
    debugPrint("Alumnado Provider inicializado");
    getAlumno();
    getHorario();
  }

  Future<List<String>> getCursos() async {
    const url = GoogleSheets.cursos;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = CursosResponse.fromJson(jsonData);
    List<String> nombres = [];

    for (int i = 0; i < cursosResponse.result.length; i++) {
      nombres.add(cursosResponse.result[i].cursoNombre);
    }
    return nombres;
  }

  Future<List<dynamic>> getAlumnos(String cursoABuscarAlumnos) async {
    const url = GoogleSheets.alumnos;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = AlumnosResponse.fromJson(jsonData);
    List<dynamic> nombresAlumnos = [];
    for (int i = 0; i < cursosResponse.result.length; i++) {
      if (cursosResponse.result[i].curso == cursoABuscarAlumnos) {
        nombresAlumnos.add(cursosResponse.result[i].nombre);
      }
    }
    return nombresAlumnos;
  }

  Future<void> getAlumno() async {
    const url =GoogleSheets.alumnos;
        
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = AlumnosResponse.fromJson(jsonData);
    listadoAlumnos = cursosResponse.result;
    notifyListeners();
  }

  Future<void> getHorario() async {
    const url = GoogleSheets.horarios;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = HorarioResponse.fromJson(jsonData);
    listadoHorarios = cursosResponse.result;
    notifyListeners();
  }
}
