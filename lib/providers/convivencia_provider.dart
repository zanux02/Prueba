import 'package:flutter/material.dart';
import 'package:kk/models/models.dart';
import 'package:kk/utils/utilidades.dart';

class ConvivenciaProvider extends ChangeNotifier {
  //Script Google
  //https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1ZcdgFdnsp69tXP-S2VVwRM2z3Ucmv2EPrOkH9QIp4nA&sheet=Expulsados
  //Google Docs Convivencia

  List<Expulsado> listaExpulsados = [];
  List<Mayor> listaMayores = [];

  ConvivenciaProvider() {
    debugPrint('Convivencia Provider inicializada');
    getExpulsados();
    getMayores();
    notifyListeners();
  }

  getExpulsados() async {
    const url =
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1cu_ZSghIYglmF48s4xGE97Pudj9-xlVue02rLoI-s-s&sheet=Pruebas";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final expulsadoResponse = ExpulsadosResponse.fromJson(jsonData);
    listaExpulsados = [...expulsadoResponse.results];

    notifyListeners();
  }

  getMayores() async {
    const url =
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1ZcdgFdnsp69tXP-S2VVwRM2z3Ucmv2EPrOkH9QIp4nA&sheet=Mayores";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final mayorResponse = MayoresResponse.fromJson(jsonData);
    listaMayores = [...mayorResponse.results];

    notifyListeners();
  }
}
