import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kk/providers/profesor_provider.dart';
import 'package:kk/models/horario_response.dart';

class HorarioProfesoresDetallesScreen extends StatelessWidget {
  const HorarioProfesoresDetallesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final profesorProvider =
        Provider.of<ProfesorProvider>(context, listen: false);
    final listadoProfesores = profesorProvider.listadoProfesor;
    final listadoHorarios = profesorProvider.listadoHorarios;

    Set<String> horasUnicas =
        listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = [
      "8:00",
      "9:00",
      "10:00",
      "11:00",
      "11:30",
      "12:30",
      "13:30",
      "14:30"
    ];
    List<String> horasFiltradas =
        horasOrdenadas.where((hora) => horasUnicas.contains(hora)).toList();

    List<String> diasOrdenados = ["L", "M", "X", "J", "V"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "HORARIO DE ${listadoProfesores[index].nombre}",
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
                  _buildDiasSemana(diasOrdenados),
                  for (int i = 0; i < horasFiltradas.length; i++)
                    _buildHorarioRow(context, listadoHorarios, horasFiltradas[i],
                        diasOrdenados, listadoProfesores[index].nombre),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildDiasSemana(List<String> diasOrdenados) {
    List<Widget> widgetsDias = [];

    for (var dia in diasOrdenados) {
      widgetsDias.add(
        Container(
          color: Colors.blue,
          child: Center(
            child: Text(
              dia,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return TableRow(children: widgetsDias);
  }

  TableRow _buildHorarioRow(BuildContext context,
      List<HorarioResult> listadoHorarios,
      String horaInicio,
      List<String> diasOrdenados,
      String nombreProfesor) {
    List<Widget> widgetsClases = [];

    String horaFin = _calculateEndTime(horaInicio);

    for (var dia in diasOrdenados) {
      String asignatura = "";
      String aula = "";

      bool asignado = false;
      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].dia.startsWith(dia) &&
            listadoHorarios[i].hora == horaInicio &&
            listadoHorarios[i].nombreProfesor == nombreProfesor) {
          asignatura = listadoHorarios[i].asignatura;
          aula = listadoHorarios[i].aulas;
          asignado = true;
          break;
        }
      }

      if (!asignado) {
        asignatura = "";
        aula = "";
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

    return TableRow(
      children: [
        Container(
          color: Colors.blue,
          child: Column(
            children: [
              Text(
                "$horaInicio  -  $horaFin",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ...widgetsClases,
      ],
    );
  }

  String _calculateEndTime(String horaInicio) {
    final parts = horaInicio.split(":");
    int startHour = int.parse(parts[0]);
    int startMinute = int.parse(parts[1]);

    int endHour = startHour + 1;

    String formattedEndHour = endHour.toString().padLeft(2, '0');
    String formattedEndMinute = startMinute.toString().padLeft(2, '0');

    return "$formattedEndHour:$formattedEndMinute";
  }
}
