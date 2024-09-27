import 'package:flutter/material.dart';

import 'package:iJandula/models/horario_response.dart';
import 'package:iJandula/models/profesor_response.dart';
import 'package:iJandula/utils/google_sheets.dart';
import 'package:iJandula/utils/utilidades.dart';

class ProfesorProvider extends ChangeNotifier{
  List<ProfesorRes> listadoProfesor = [];
  List<HorarioResult> listadoHorarios = [];

   ProfesorProvider() {
    debugPrint("Profesor Provider inicalizado");
    getHorario();
    getProfesor();
  }

  getHorario() async {
    const url = GoogleSheets.horarios;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = HorarioResponse.fromJson(jsonData);
    listadoHorarios = cursosResponse.result;
    notifyListeners();
  }

  getProfesor() async {
    const url = GoogleSheets.credenciales;
        
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final responseProfesor = ProfesorResponse.fromJson(jsonData);
    listadoProfesor = responseProfesor.result;
    notifyListeners();
  }
}
  


