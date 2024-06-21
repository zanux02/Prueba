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

    listaOrdenada.sort((a, b) => a.nombre.compareTo(b.nombre));
    return Scaffold(
      appBar: AppBar(title: const Text("LOCALIZACION PROFESORES")),
      body: ListView.builder(
        itemCount: listaOrdenada.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _mostrarAlert(
                  context, index, listaOrdenada[index], listadoHorarios);
            },
            child: ListTile(
              title: Text(
                  "${listaOrdenada[index].nombre} ${listaOrdenada[index].apellidos}"),
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index, ProfesorRes profesor,
      List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();
    int horaActual = ahora.hour;
    int minutoActual = ahora.minute;
    String diaActual = obtenerDiaSemana(ahora.weekday);

    // Filtrar los horarios del profesor actual para el día actual
    List<HorarioResult> horariosProfesor = listadoHorarios.where((horario) =>
            horario.nombreProfesor == profesor.nombre &&
            horario.apellidoProfesor == profesor.apellidos &&
            horario.dia.startsWith(diaActual))
        .toList();

    String asignatura = "";
    String aula = "";
    String texto = "";

    // Iterar sobre los horarios del profesor actual
    for (int i = 0; i < horariosProfesor.length; i++) {
      String horaInicio = horariosProfesor[i].hora;
      String horaFin = sumarHora(horaInicio);

      // Convertir horas a enteros para la comparación
      int horaInicioInt = int.parse(horaInicio.split(":")[0]);
      int minutoInicioInt = int.parse(horaInicio.split(":")[1]);
      int horaFinInt = int.parse(horaFin.split(":")[0]);
      int minutoFinInt = int.parse(horaFin.split(":")[1]);

      // Verificar si la hora actual está dentro del rango de la clase
      if ((horaActual > horaInicioInt ||
              (horaActual == horaInicioInt && minutoActual >= minutoInicioInt)) &&
          (horaActual < horaFinInt ||
              (horaActual == horaFinInt && minutoActual < minutoFinInt))) {
        asignatura = horariosProfesor[i].asignatura;
        aula = horariosProfesor[i].aulas;
        break; // Se encontró la clase, salir del bucle
      }
    }

    // Construir el mensaje a mostrar en el AlertDialog
    if (aula.isEmpty || asignatura.isEmpty) {
      texto =
          "El profesor ${profesor.nombre} ${profesor.apellidos} no está disponible en este momento";
    } else {
      texto =
          "El profesor ${profesor.nombre} ${profesor.apellidos} está actualmente en el aula $aula, impartiendo la asignatura $asignatura";
    }

    // Mostrar el AlertDialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("${profesor.nombre} ${profesor.apellidos}"),
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

  // Función para sumar una hora a la hora inicial
  String sumarHora(String hora) {
    int horas = int.parse(hora.split(":")[0]) + 1;
    int minutos = int.parse(hora.split(":")[1]);

    // Formatear los minutos a dos dígitos
    String minutosString = minutos.toString().padLeft(2, '0');

    return "$horas:$minutosString";
  }

  // Función para obtener el día de la semana en formato 'L', 'M', etc.
  String obtenerDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'L';
      case DateTime.tuesday:
        return 'M';
      case DateTime.wednesday:
        return 'X';
      case DateTime.thursday:
        return 'J';
      case DateTime.friday:
        return 'V';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'D';
      default:
        return '';
    }
  }
}
