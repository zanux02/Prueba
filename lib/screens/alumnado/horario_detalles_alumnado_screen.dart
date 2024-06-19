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
                diasSemana(),
                for (int i = 0; i < 6; i++)
                  diaHorario(context, index, listadoHorarios, i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow diasSemana() {
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"];
    List<Widget> widgetsDias = [Container()];

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

  TableRow diaHorario(BuildContext context, int index,
      List<HorarioResult> listadoHorarios, int horaDia) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;

    // Get the horarios for the specific curso
    List<HorarioResult> cursoHorarios = listadoHorarios
        .where((horario) => horario.curso == listadoAlumnos[index].curso)
        .toList();

    // Predefined sorted list of hours
    List<String> sortedHours = ["8:00", "9:00", "10:00", "11:00", "12:00", "13:00"];

    List<Widget> widgetsClases = [];

    for (int numDia = 0; numDia < 5; numDia++) {
      String asignatura = "";
      String aula = "";

      for (int i = 0; i < cursoHorarios.length; i++) {
        if (cursoHorarios[i].dia.substring(0, 1) == ['L', 'M', 'X', 'J', 'V'][numDia] &&
            cursoHorarios[i].hora.split(":")[0] == sortedHours[horaDia].split(":")[0]) {
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
          sortedHours[horaDia],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }
}
