import 'package:flutter/material.dart';

import 'package:iJandula/models/horario_response.dart';
import 'package:iJandula/models/profesor_response.dart';
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
    const url = "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=11Y4M52bYFMCIa5uU52vKll2-OY0VtFiGK2PhMWShngg&sheet=Horarios";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = HorarioResponse.fromJson(jsonData);
    listadoHorarios = cursosResponse.result;
    notifyListeners();
  }

  getProfesor() async {
    const url ="https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1qREuUYht73nx_fS2dxm9m6qPs_uvBwsK74dOprmwdjE&sheet=Credenciales";
        
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final responseProfesor = ProfesorResponse.fromJson(jsonData);
    listadoProfesor = responseProfesor.result;
    notifyListeners();
  }
}
  


