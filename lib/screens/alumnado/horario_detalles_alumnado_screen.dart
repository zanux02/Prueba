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
            Container(
              color: Colors.blue,
              child: Table(
                border: TableBorder.all(style: BorderStyle.solid),
                children: [
                  diasSemana(listadoHorarios),
                  diaHorario(context, index, listadoHorarios, 0),
                  diaHorario(context, index, listadoHorarios, 1),
                  diaHorario(context, index, listadoHorarios, 2),
                  diaHorario(context, index, listadoHorarios, 3),
                  diaHorario(context, index, listadoHorarios, 4),
                  diaHorario(context, index, listadoHorarios, 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow diasSemana(List<HorarioResult> listadoHorarios) {
    Set<String> diasUnicos =
        listadoHorarios.map((horario) => horario.dia.substring(0, 1)).toSet();
    List<String> diasOrdenados = ["L", "M", "X", "J", "V"];
    List<Widget> widgetsDias = [];

    widgetsDias.add(Container());

    for (var dia in diasOrdenados) {
      if (diasUnicos.contains(dia)) {
        widgetsDias.add(
          Center(
            child: Text(
              dia,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
        widgetsDias.add(Container());
      }
    }

    return TableRow(children: widgetsDias);
  }

  TableRow diaHorario(
      BuildContext context, int index, List<HorarioResult> listadoHorarios, int horaDia) {
    final horario = [
      "8:00 a 9:00",
      "9:00 a 10:00",
      "10:00 a 11:00",
      "11:00 a 12:00",
      "12:00 a 13:00",
      "13:00 a 14:00"
    ];
    List<Widget> widgetsClases = [];

    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;

    for (int numDia = 0; numDia < 5; numDia++) {
      String asignatura = "";
      String aula = "";

      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].curso == listadoAlumnos[index].curso &&
            listadoHorarios[i].dia.substring(0, 1) == ['L', 'M', 'X', 'J', 'V'][numDia] &&
            int.parse(listadoHorarios[i].hora.split(":")[0]) == [8, 9, 10, 11, 12, 13][horaDia]) {
          asignatura = listadoHorarios[i].asignatura;
          aula = listadoHorarios[i].aulas;
          break;
        }
      }

      widgetsClases.add(
        Column(
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
      );
    }

    return TableRow(children: [
      Container(
        color: Colors.blue,
        child: Text(
          horario[horaDia],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }
}
