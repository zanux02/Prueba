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
    List<String> horasOrdenadas = horasUnicas.toList()..sort();

    // Ordenar los días de la semana
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"];

    return Scaffold(
      appBar: AppBar(
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
                  for (int i = 0; i < horasOrdenadas.length; i++)
                    _buildHorarioRow(context, listadoHorarios, horasOrdenadas[i], diasOrdenados),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildDiasSemana(List<String> diasOrdenados) {
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

  TableRow _buildHorarioRow(BuildContext context, List<HorarioResult> listadoHorarios, String horaInicio, List<String> diasOrdenados) {
    List<Widget> widgetsClases = [];

    // Calcular la hora de fin sumando 1 hora a la hora de inicio
    String horaFin = _calculateEndTime(horaInicio);

    // Recorrer los días de la semana
    for (var dia in diasOrdenados) {
      String asignatura = "";
      String aula = "";

      // Buscar la asignatura y el aula correspondiente para cada día y hora
      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].dia.startsWith(dia) && listadoHorarios[i].hora == horaInicio) {
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

    return TableRow(
      children: [
        Container(
          color: Colors.blue,
          child: Column(
            children: [
              Text(
                "$horaInicio - $horaFin",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
    // Parsear la hora de inicio
    final parts = horaInicio.split(":");
    int startHour = int.parse(parts[0]);
    int startMinute = int.parse(parts[1]);

    // Calcular la hora de fin sumando 1 hora
    int endHour = startHour + 1;

    // Formatear la hora de fin
    String formattedEndHour = endHour.toString().padLeft(2, '0');
    String formattedEndMinute = startMinute.toString().padLeft(2, '0');

    return "$formattedEndHour:$formattedEndMinute";
  }
}
