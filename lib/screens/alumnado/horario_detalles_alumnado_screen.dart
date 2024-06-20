import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kk/providers/profesor_provider.dart';
import 'package:kk/models/horario_response.dart';

class HorarioProfesoresDetallesScreen extends StatelessWidget {
  const HorarioProfesoresDetallesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final profesorProvider = Provider.of<ProfesorProvider>(context, listen: false);
    final listadoProfesores = profesorProvider.listadoProfesor;
    final listadoHorarios = profesorProvider.listadoHorarios;

    // Crear lista de horas a partir de los horarios disponibles
    Set<String> horasUnicas = listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = horasUnicas.toList()
      ..sort((a, b) => _compareHours(a, b));

    // Crear lista de días a partir de los horarios disponibles
    List<String> diasOrdenados = _getDiasOrdenados(listadoHorarios);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HORARIO DE ${listadoProfesores[index].nombre} ",
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              child: Table(
                border: TableBorder.all(style: BorderStyle.solid),
                children: [
                  diasSemana(diasOrdenados),
                  for (int i = 0; i < horasOrdenadas.length; i++)
                    diaHorario(context, index, listadoHorarios, horasOrdenadas[i]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow diasSemana(List<String> diasOrdenados) {
    List<Widget> widgetsDias = [Container()];

    for (var dia in diasOrdenados) {
      widgetsDias.add(
        Container(
          color: Colors.blue,
          child: Center(
            child: Text(
              dia,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return TableRow(children: widgetsDias);
  }

  TableRow diaHorario(BuildContext context, int index, List<HorarioResult> listadoHorarios, String hora) {

    List<Widget> widgetsClases = [];

    for (int numDia = 0; numDia < _getDiasOrdenados(listadoHorarios).length; numDia++) {
      String asignatura = "";
      String aula = "";

      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].dia.startsWith(_getDiasOrdenados(listadoHorarios)[numDia]) &&
            listadoHorarios[i].hora == hora) {
          asignatura = listadoHorarios[i].asignatura;
          aula = listadoHorarios[i].aulas;
          break;
        }
      }

      widgetsClases.add(
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                asignatura.isNotEmpty ? asignatura.toUpperCase().substring(0, 3) : '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                aula.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return TableRow(children: [
      Container(
        color: Colors.blue,
        child: Text(
          _formatHourRange(hora),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }

  List<String> _getDiasOrdenados(List<HorarioResult> listadoHorarios) {
    Set<String> diasUnicos = listadoHorarios.map((horario) => horario.dia.substring(0, 1)).toSet();
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"].where((dia) => diasUnicos.contains(dia)).toList();
    return diasOrdenados;
  }

  int _compareHours(String a, String b) {
    // Comparar horas en formato "HH:mm"
    final partsA = a.split(":");
    final partsB = b.split(":");
    final hourA = int.parse(partsA[0]);
    final minuteA = int.parse(partsA[1]);
    final hourB = int.parse(partsB[0]);
    final minuteB = int.parse(partsB[1]);

    if (hourA != hourB) {
      return hourA.compareTo(hourB);
    } else {
      return minuteA.compareTo(minuteB);
    }
  }

  String _formatHourRange(String hour) {
    // Formatear la hora en formato "HH:mm"
    final parts = hour.split(":");
    final startHour = int.parse(parts[0]);
    final startMinutes = int.parse(parts[1]);

    final endHour = startHour + 1;
    final endMinutes = startMinutes == 30 ? "30" : "00";

    return "$hour - ${endHour.toString().padLeft(2, '0')}:$endMinutes";
  }
}
