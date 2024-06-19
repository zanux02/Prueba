import 'package:flutter/material.dart';

import 'package:kk/models/horario_response.dart';
import 'package:kk/models/profesor_horario_response.dart';
import 'package:kk/utils/utilidades.dart';

class ProfesorProvider extends ChangeNotifier{
  List<ProfesorHorarioResult> listadoProfesor = [];
  List<HorarioResult> listadoHorarios = [];

   ProfesorProvider() {
    debugPrint("Profesor Provider inicalizado");
    getHorario();
    getProfesor();
  }

  getHorario() async {
    const url = "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=11Y4M52bYFMCIa5uU52vKll2-OY0VtFiGK2PhMWShngg&sheet=Horarios";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = HorarioResponse.fromJson(jsonData);
    listadoHorarios = cursosResponse.result;
    notifyListeners();
  }

  getProfesor() async {
    const url ="https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=11Y4M52bYFMCIa5uU52vKll2-OY0VtFiGK2PhMWShngg&sheet=Horarios";
        
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = ProfesorHorarioResponse.fromJson(jsonData);
    listadoProfesor = cursosResponse.result;
    notifyListeners();
  }
}
  


