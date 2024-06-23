import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iJandula/models/servicio_response.dart';
import 'package:iJandula/utils/utilidades.dart';

class ServicioProvider extends ChangeNotifier {
  List<Servicio> listadoAlumnosServicio = [];

  final _url = "script.google.com";
  final _apiEscritura = "macros/s/AKfycbz7ZwCTn2XXpXuPO2-m9tyR1sIC9lOMgvPPOsbDehda2NRoko871PvZvzF1jQnaq8Du/exec";
  final _idHoja = "1Jq4ihUzE5r4fqK9HHZQv1dg4AAgzdjPbGkpJRByu-Ds";
  final _hojaServicio = "Servicio";

  ServicioProvider() {
    debugPrint("Servicio Provider inicializado");
    getAlumnosServicio();
    notifyListeners();
  }

  getAlumnosServicio() async {
    const url = "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I&sheet=Servicio";
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final servicioResponse = ServicioResponse.fromJson(jsonData);
    listadoAlumnosServicio = servicioResponse.result;
    notifyListeners();
  }

  _setAlumnos(String baseUrl, String api, String spreadsheetId, String sheet, String nombreAlumno, String fechaEntrada, String fechaSalida) async {
    final url = Uri.https(baseUrl, api, {
      "spreadsheetId": spreadsheetId,
      "sheet": sheet,
      "nombreAlumno": nombreAlumno,
      "fechaEntrada": fechaEntrada,
      "fechaSalida": fechaSalida
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint('Datos enviados correctamente');
      } else {
        debugPrint('Error al enviar los datos: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  setAlumnosServicio(String nombreAlumno, String fechaEntrada, String fechaSalida) {
    _setAlumnos(_url, _apiEscritura, _idHoja, _hojaServicio, nombreAlumno, fechaEntrada, fechaSalida);
    notifyListeners();
  }
}
