import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iJandula/models/servicio_response.dart';
import 'package:iJandula/utils/utilidades.dart';

class ServicioProvider extends ChangeNotifier {
  List<Servicio> listadoAlumnosServicio = [];

  final String _baseUrl =
      'https://script.google.com/macros/s/AKfycbww17NqHZU5opz9SkMtUASKZOg1Hg6KsExRSvlqAMyrx4i0Ax9P5I7IQtKRcnsMKVivdw/exec';
  final String _idHoja = '1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I';
  final String _hojaServicio = 'Servicio';

  ServicioProvider() {
    debugPrint('Servicio Provider inicializado');
    getAlumnosServicio();
  }

  Future<void> getAlumnosServicio() async {
    try {
      const url =
          'https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I&sheet=Servicio';
      String jsonData = await Utilidades.getJsonData(url);
      jsonData = '{"results":$jsonData}';
      final servicioResponse = ServicioResponse.fromJson(jsonData);
      listadoAlumnosServicio = servicioResponse.result;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al obtener los datos: $e');
    }
  }

  Future<void> setAlumnosServicio(
      String nombreAlumno,
      String fechaEntrada,
      String horaEntrada,
      String fechaSalida,
      String horaSalida) async {
    try {
      final url = Uri.parse(
          '$_baseUrl?spreadsheetId=$_idHoja&sheet=$_hojaServicio&nombreAlumno=$nombreAlumno&fechaEntrada=$fechaEntrada%20$horaEntrada&fechaSalida=$fechaSalida%20$horaSalida');
      
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
}
