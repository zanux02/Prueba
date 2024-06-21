import 'package:flutter/material.dart';
import 'package:kk/models/alumnos_response.dart';
import 'package:kk/models/horario_response.dart';

void _mostrarAlert(BuildContext context, int index,
      List<DatosAlumnos> listaAlumnos, List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();

    List<HorarioResult> listadoHorarioCurso = [];
    for (int i = 0; i < listadoHorarios.length; i++) {
      if (listaAlumnos[index].curso == listadoHorarios[i].curso) {
        listadoHorarioCurso.add(listadoHorarios[i]);
      }
    }

    int horaActual = ahora.hour;
    int minutosActual = ahora.minute;
    int dia = ahora.weekday;

    String asignatura = "";
    String aula = "";
    String texto = "";

    List<HorarioResult> listadoHorarioCursoDia = [];
    for (int i = 0; i < 6; i++) {
      if (dia == 1) {
        listadoHorarioCursoDia.add(listadoHorarioCurso[i]);
      } else {
        listadoHorarioCursoDia.add(listadoHorarioCurso[i + (6 * (dia - 1))]);
      }
    }

    bool alumnoEnClase = false;
    for (int i = 0; i < listadoHorarioCursoDia.length; i++) {
      String horaInicio = listadoHorarioCursoDia[i].hora;
      String horaFin = _calculateEndTime(horaInicio);

      // Parsear la hora de inicio y fin
      int startHour = int.parse(horaInicio.split(":")[0]);
      int startMinute = int.parse(horaInicio.split(":")[1]);
      int endHour = int.parse(horaFin.split(":")[0]);
      int endMinute = int.parse(horaFin.split(":")[1]);

      // Comparar la hora actual con la hora de inicio y fin de la asignatura
      if ((horaActual > startHour || (horaActual == startHour && minutosActual >= startMinute)) &&
          (horaActual < endHour || (horaActual == endHour && minutosActual < endMinute))) {
        asignatura = listadoHorarioCursoDia[i].asignatura;
        aula = listadoHorarioCursoDia[i].aulas;
        alumnoEnClase = true;
        break;
      }
    }

    if (!alumnoEnClase) {
      texto = "El alumno no está disponible en este momento";
    } else {
      texto =
          "El alumno ${listaAlumnos[index].nombre} se encuentra actualmente en el aula $aula, en la asignatura $asignatura";
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(listaAlumnos[index].nombre),
            content: Text(texto),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar")),
            ],
          );
        });
  }

  String _calculateEndTime(String horaInicio) {
    final parts = horaInicio.split(":");
    int startHour = int.parse(parts[0]);
    int startMinute = int.parse(parts[1]);

    // Calcular la hora de fin
    int endHour = startHour;
    int endMinute = startMinute == 30 ? 0 : 30;
    if (startMinute == 30) {
      endHour++;
    }

    String formattedEndHour = endHour.toString().padLeft(2, '0');
    String formattedEndMinute = endMinute.toString().padLeft(2, '0');

    return "$formattedEndHour:$formattedEndMinute";
  }
