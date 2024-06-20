import 'package:flutter/material.dart';
import 'package:kk/models/models.dart';
import 'package:kk/utils/peticion_expulsados.dart';
import 'package:kk/utils/human_formats.dart';

class ExpulsadosProvider extends ChangeNotifier {
  String seleccionCursos = ''; 
  String seleccionAula = ''; 
  DateTime selectedDate = DateTime.now();

  Map<String, List<String>> cursos = {};

  ExpulsadosProvider() {
    debugPrint('Convivencia Provider inicializada');
    getCursos();
    notifyListeners();
  }

  Future<List<Expulsado>> getExpulsados() async {
    final List<Expulsado> expulsadoResponse = await PeticionExpulsados().getExpulsados();

    // Filtrar la lista de expulsados por la fecha seleccionada
    List<Expulsado> expulsadosFiltrados = expulsadoResponse.where((expulsado) {
      DateTime fecInic = HumanFormats.formatStringToDate(expulsado.fecInic);
      DateTime fecFin = HumanFormats.formatStringToDate(expulsado.fecFin);
      return selectedDate.isAtSameMomentAs(fecInic) ||
          selectedDate.isAtSameMomentAs(fecFin) ||
          (selectedDate.isAfter(fecInic) && selectedDate.isBefore(fecFin));
    }).toList();

    return expulsadosFiltrados;
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
    }
    notifyListeners();
  }

  Future<void> getCursos() async {
    Map<String, List<String>> cursos = {
      'ESO': ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C', '4A', '4B', '4C'],
      'BACH': ['1A', '1B', '1C', '1D', '2A', '2B'],
      'CICLOS': ['1FPB', '2FPB', '1DAM', '2DAM', '1DAW', '2DAW']
    };

    Future.delayed(const Duration(seconds: 2));

    this.cursos = cursos;
    seleccionCursos = cursos.keys.first;
    seleccionAula = cursos[seleccionCursos]![0];
    notifyListeners();
  }

  void setSeleccionCursos(String value){
    seleccionCursos = value;
    seleccionAula = cursos[seleccionCursos]![0];
    notifyListeners(); 
  }

  void setSeleccionAulas(String value){
    seleccionAula = value;
    notifyListeners(); 
  }
}
