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

    // Ordenar los días de la semana
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"];

    // Crear lista de horas únicas y ordenarlas
    Set<String> horasUnicas = listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = horasUnicas.toList()..sort();

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
                    diaHorario(context, listadoHorarios, horasOrdenadas[i], diasOrdenados),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow diasSemana(List<String> diasOrdenados) {
    List<Widget> widgetsDias = [];

    // Agregar una celda vacía para la columna de horas
    widgetsDias.add(Container());

    // Agregar los días de la semana ordenados
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

  TableRow diaHorario(BuildContext context, List<HorarioResult> listadoHorarios, String hora, List<String> diasOrdenados) {
    List<Widget> widgetsClases = [];

    // Recorrer los días ordenados
    for (var dia in diasOrdenados) {
      String asignatura = "";
      String aula = "";

      // Buscar la asignatura y el aula correspondiente para cada día y hora
      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].dia.startsWith(dia) && listadoHorarios[i].hora == hora) {
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

    // Calcular hora de fin basada en la duración estándar de una hora (60 minutos)
    String horaFin = _calculateEndTime(hora);

    return TableRow(children: [
      Container(
        color: Colors.blue,
        child: Column(
          children: [
            Text(
              "$hora - $horaFin",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ...widgetsClases,
    ]);
  }

  String _calculateEndTime(String horaInicio) {
    // Obtener la hora de inicio y los minutos
    List<String> parts = horaInicio.split(":");
    int startHour = int.parse(parts[0]);
    int startMinute = int.parse(parts[1]);

    // Calcular la hora de fin sumando 1 hora
    int endHour = startHour + 1;
    int endMinute = startMinute;

    // Formatear la hora de fin
    String formattedEndHour = endHour.toString().padLeft(2, '0');
    String formattedEndMinute = endMinute.toString().padLeft(2, '0');

    return "$formattedEndHour:$formattedEndMinute";
  }
}
