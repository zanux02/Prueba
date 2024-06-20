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

    // Get unique days sorted and remove numbers
    Set<String> diasUnicos = listadoHorarios.map((horario) => horario.dia.substring(0, 1)).toSet();
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"].where((dia) => diasUnicos.contains(dia)).toList();

    // Get unique hours sorted
    Set<String> horasUnicas = listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = horasUnicas.toList()
      ..sort((a, b) => int.parse(a.split(":")[0]).compareTo(int.parse(b.split(":")[0])));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HORARIO DE ${listadoAlumnos[index].curso} ",
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
                diasSemana(diasOrdenados),
                for (int i = 0; i < horasOrdenadas.length; i++)
                  diaHorario(context, index, listadoHorarios, i, diasOrdenados, horasOrdenadas),
              ],
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

  TableRow diaHorario(BuildContext context, int index, List<HorarioResult> listadoHorarios, int horaDia, List<String> diasOrdenados, List<String> horasOrdenadas) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;

    // Get the horarios for the specific curso
    List<HorarioResult> cursoHorarios = listadoHorarios
        .where((horario) => horario.curso == listadoAlumnos[index].curso)
        .toList();

    List<Widget> widgetsClases = [];

    for (int numDia = 0; numDia < diasOrdenados.length; numDia++) {
      String asignatura = "";
      String aula = "";

      for (int i = 0; i < cursoHorarios.length; i++) {
        if (cursoHorarios[i].dia.startsWith(diasOrdenados[numDia]) &&
            cursoHorarios[i].hora == horasOrdenadas[horaDia]) {
          asignatura = cursoHorarios[i].asignatura;
          aula = cursoHorarios[i].aulas;
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
          _formatHourRange(horasOrdenadas[horaDia]),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }

  String _formatHourRange(String hour) {
    final startHour = int.parse(hour.split(":")[0]);
    final endHour = startHour + 1;
    return "$hour a $endHour:00";
  }
}
