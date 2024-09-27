import 'package:flutter/material.dart';
import 'package:iJandula/models/models.dart';
import 'package:iJandula/utils/utilidades.dart';
import 'package:iJandula/utils/google_sheets.dart';

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
    const url = GoogleSheets.expulsados;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final expulsadoResponse = ExpulsadosResponse.fromJson(jsonData);
    listaExpulsados = [...expulsadoResponse.results];
    notifyListeners();
  }

  Future<void> getMayores() async {
    const url = GoogleSheets.mayores;
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
