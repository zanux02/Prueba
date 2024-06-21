import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kk/providers/alumnado_provider.dart';
import 'package:kk/models/horario_response.dart';

class HorarioDetallesAlumnadoScreen extends StatelessWidget {
  const HorarioDetallesAlumnadoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;
    final listadoHorarios = alumnadoProvider.listadoHorarios;

    // Obtener horas únicas ordenadas
    Set<String> horasUnicas = listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = horasUnicas.toList()
      ..sort((a, b) => _compareHours(a, b));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HORARIO DE ${listadoAlumnos[index].curso}",
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Table(
              border: TableBorder.all(style: BorderStyle.solid),
              children: [
                _buildDaysRow(listadoHorarios),
                for (int i = 0; i < horasOrdenadas.length; i++)
                  _buildScheduleRow(context, index, listadoHorarios, i, horasOrdenadas),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Comparar horas para ordenarlas correctamente
  int _compareHours(String a, String b) {
    final aHour = int.parse(a.split(":")[0]);
    final aMinute = int.parse(a.split(":")[1]);
    final bHour = int.parse(b.split(":")[0]);
    final bMinute = int.parse(b.split(":")[1]);

    if (aHour == bHour) {
      return aMinute.compareTo(bMinute);
    } else {
      return aHour.compareTo(bHour);
    }
  }

  // Construir la fila de días de la semana
  TableRow _buildDaysRow(List<HorarioResult> listadoHorarios) {
    // Obtener días únicos ordenados
    Set<String> diasUnicos = listadoHorarios.map((horario) => horario.dia.substring(0, 1)).toSet();
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"].where((dia) => diasUnicos.contains(dia)).toList();

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

  // Construir fila del horario
  TableRow _buildScheduleRow(BuildContext context, int index, List<HorarioResult> listadoHorarios, int horaIndex, List<String> horasOrdenadas) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;

    // Filtrar horarios por curso y hora
    List<HorarioResult> cursoHorarios = listadoHorarios
        .where((horario) => horario.curso == listadoAlumnos[index].curso && horario.hora == horasOrdenadas[horaIndex])
        .toList();

    List<Widget> widgetsClases = [];

    for (int diaIndex = 0; diaIndex < 5; diaIndex++) {
      String asignatura = "";
      String aula = "";

      // Encontrar la clase correspondiente al día y hora
      HorarioResult? claseEncontrada;
      for (int i = 0; i < cursoHorarios.length; i++) {
        if (cursoHorarios[i].dia.startsWith(["L", "M", "X", "J", "V"][diaIndex])) {
          claseEncontrada = cursoHorarios[i];
          break;
        }
      }

      // Verificar si hay clase en este momento
      bool isInClass = false;
      if (claseEncontrada != null) {
        isInClass = _isInClassTime(horasOrdenadas[horaIndex], claseEncontrada.hora);
        if (isInClass) {
          asignatura = claseEncontrada.asignatura;
          aula = claseEncontrada.aulas;
        }
      }

      // Mostrar la asignatura y aula si corresponde, o indicar que no hay clase en ese momento
      if (isInClass) {
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
      } else {
        widgetsClases.add(
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                "NO CLASE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }
    }

    return TableRow(children: [
      Container(
        color: Colors.blue,
        child: Text(
          _formatHourRange(horasOrdenadas[horaIndex]),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }

  // Formatear el rango de horas
  String _formatHourRange(String hour) {
    final parts = hour.split(":");
    final startHour = int.parse(parts[0]);
    final startMinutes = int.parse(parts[1]);

    final endHour = startHour + 1;
    final endMinutes = startMinutes == 30 ? "30" : "00";

    return "$hour - $endHour:$endMinutes";
  }

  // Verificar si la hora actual está dentro del rango de la clase
  bool _isInClassTime(String startTime, String classTime) {
    final startHour = int.parse(startTime.split(":")[0]);
    final startMinute = int.parse(startTime.split(":")[1]);

    final classHour = int.parse(classTime.split(":")[0]);
    final classMinute = int.parse(classTime.split(":")[1]);

    if (startHour == classHour) {
      // Misma hora, comprobar minutos
      return startMinute < classMinute;
    } else {
      // Si la hora de inicio es anterior a la hora de clase, está en clase
      return startHour < classHour;
    }
  }
}
