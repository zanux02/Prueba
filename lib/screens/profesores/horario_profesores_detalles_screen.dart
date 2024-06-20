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
                  diasSemana(),
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

  TableRow diasSemana() {
    return TableRow(children: [
      Container(),
      const Text("L", textAlign: TextAlign.center),
      const Text("M", textAlign: TextAlign.center),
      const Text("X", textAlign: TextAlign.center),
      const Text("J", textAlign: TextAlign.center),
      const Text("V", textAlign: TextAlign.center),
    ]);
  }

  TableRow diaHorario(BuildContext context, int index, List<HorarioResult> listadoHorarios, String hora) {


    List<Widget> widgetsClases = [];

    for (int numDia = 0; numDia < 5; numDia++) { // Asumiendo L, M, X, J, V
      String asignatura = "";
      String aula = "";

      for (int i = 0; i < listadoHorarios.length; i++) {
        if (listadoHorarios[i].dia.startsWith(_getDiaSemana(numDia)) &&
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
          hora,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      ...widgetsClases,
    ]);
  }

  String _getDiaSemana(int index) {
    switch (index) {
      case 0:
        return "L";
      case 1:
        return "M";
      case 2:
        return "X";
      case 3:
        return "J";
      case 4:
        return "V";
      default:
        return "";
    }
  }
}
