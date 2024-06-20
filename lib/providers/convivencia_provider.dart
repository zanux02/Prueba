import 'package:flutter/material.dart';
import 'package:kk/models/models.dart';
import 'package:kk/utils/utilidades.dart';

class ConvivenciaProvider extends ChangeNotifier {
  List<Expulsado> listaExpulsados = [];
  List<Mayor> listaMayores = [];
  DateTime selectedDate = DateTime.now();

  ConvivenciaProvider() {
    debugPrint('Convivencia Provider inicializada');
    getExpulsados();
    getMayores();
  }

  Future<void> getExpulsados() async {
    const url =
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1cu_ZSghIYglmF48s4xGE97Pudj9-xlVue02rLoI-s-s&sheet=Hoja1";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final expulsadoResponse = ExpulsadosResponse.fromJson(jsonData);
    listaExpulsados = [...expulsadoResponse.results];
    notifyListeners();
  }

  Future<void> getMayores() async {
    const url =
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1ZcdgFdnsp69tXP-S2VVwRM2z3Ucmv2EPrOkH9QIp4nA&sheet=Mayores";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final mayorResponse = MayoresResponse.fromJson(jsonData);
    listaMayores = [...mayorResponse.results];
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }
}
