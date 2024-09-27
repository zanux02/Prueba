import 'package:flutter/material.dart';
import 'package:iJandula/models/models.dart';
import 'package:iJandula/utils/google_sheets.dart';
import 'package:iJandula/utils/utilidades.dart';

class DaceProvider extends ChangeNotifier {
  //Script Google

  //https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1eQ_GPKIBc-ikvKQ_0FD3q-J8okY-g4uVOmyn4g4SFnU&sheet=DACE

  //Google Docs DACE
  //https://docs.google.com/spreadsheets/d/1eQ_GPKIBc-ikvKQ_0FD3q-J8okY-g4uVOmyn4g4SFnU/edit?pli=1#gid=0

  List<ResultDace> resultados = [];

  DaceProvider() {
    debugPrint("DACE Provider inicializado");
    getDaceData();
    notifyListeners();
  }

  getDaceData() async {
    const url = GoogleSheets.dace;
    final jsonData = await Utilidades.getJsonData(url);
    final daceData = DaceResponse.fromJson('{"results":$jsonData}');
    resultados = daceData.results;
    notifyListeners();
  }
}
