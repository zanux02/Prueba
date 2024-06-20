import 'package:flutter/material.dart';
import 'package:kk/models/profesor_response.dart';
import 'package:kk/providers/profesor_provider.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';

class LocalizacionProfesorScreen extends StatefulWidget {
  const LocalizacionProfesorScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacionProfesorScreen> createState() =>
      _LocalizacionProfesorScreenState();
}

class _LocalizacionProfesorScreenState
    extends State<LocalizacionProfesorScreen> {
  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesorProvider>(context);
    final listadoProfesores = profesorProvider.listadoProfesor;
    final listadoHorarios = profesorProvider.listadoHorarios;

    List<ProfesorRes> listaOrdenada = [];
    listaOrdenada.addAll(listadoProfesores);

    listaOrdenada.sort(((a, b) => a.nombre.compareTo(b.nombre)));
    return Scaffold(
      appBar: AppBar(title: const Text("LOCALIZACION PROFESORES")),
      body: ListView.builder(
        itemCount: listaOrdenada.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _mostrarAlert(context, index, listaOrdenada, listadoHorarios);
            },
            child: ListTile(
              title: Text("${listaOrdenada[index].nombre} ${listaOrdenada[index].apellidos}"),
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index,
      List<ProfesorRes> listaProfesores, List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();
    int horaActual = ahora.hour;

    List<HorarioResult> horariosProfesor = listadoHorarios.where(
      (horario) =>
          horario.nombreProfesor == listaProfesores[index].nombre &&
          horario.apellidoProfesor == listaProfesores[index].apellidos,
    ).toList();

    String asignatura = "";
    String aula = "";
    String texto = "";

    for (int i = 0; i < horariosProfesor.length; i++) {
      String horaInicio = horariosProfesor[i].hora;
      String horaFin = sumarHora(horaInicio);

      // Comprobar si la hora actual está dentro del rango de la clase
      if (horaActual >= int.parse(horaInicio.split(":")[0]) &&
          horaActual < int.parse(horaFin.split(":")[0])) {
        asignatura = horariosProfesor[i].asignatura;
        aula = horariosProfesor[i].aulas;
        break;
      }
    }

    // Si no hay asignatura ni aula, es hora de recreo
    if (aula.isEmpty || asignatura.isEmpty) {
      texto = "Es hora de recreo, el profesor no está en clase en este momento";
    } else {
      texto =
          "El profesor ${listaProfesores[index].nombre} ${listaProfesores[index].apellidos} está actualmente en el aula $aula, impartiendo la asignatura $asignatura";
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("${listaProfesores[index].nombre} ${listaProfesores[index].apellidos}"),
          content: Text(texto),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  String sumarHora(String hora) {
    int horas = int.parse(hora.split(":")[0]);
    int minutos = int.parse(hora.split(":")[1].substring(0, 2));
    String periodo = hora.split(":")[1].substring(2);
    if (periodo == "00") {
      horas += 1;
    } else {
      horas += 2;
    }
    return "$horas:00";
  }
}
