import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/alumnado_provider.dart';

class LocalizacionAlumnadoScreen extends StatefulWidget {
  const LocalizacionAlumnadoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacionAlumnadoScreen> createState() =>
      _LocalizacionAlumnadoScreenState();
}

class _LocalizacionAlumnadoScreenState
    extends State<LocalizacionAlumnadoScreen> {
  @override
  Widget build(BuildContext context) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;
    final listadoHorarios = alumnadoProvider.listadoHorarios;

    List<DatosAlumnos> listaOrdenada = [];
    listaOrdenada.addAll(listadoAlumnos);

    listaOrdenada.sort((a, b) => a.nombre.compareTo(b.nombre));
    return Scaffold(
      appBar: AppBar(title: const Text("LOCALIZACION ALUMNOS")),
      body: ListView.builder(
        itemCount: listaOrdenada.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _mostrarAlert(context, index, listaOrdenada, listadoHorarios);
            },
            child: ListTile(
              title: Text(listaOrdenada[index].nombre),
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index,
      List<DatosAlumnos> listaAlumnos, List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();

    // Obtener el día de la semana (1=Lunes, 7=Domingo)
    int dia = ahora.weekday;

    // Filtrar los horarios por el curso del alumno
    List<HorarioResult> listadoHorarioCurso = listadoHorarios
        .where((horario) => horario.curso == listaAlumnos[index].curso)
        .toList();

    String asignatura = "";
    String aula = "";
    String texto = "";

    // Buscar los horarios para el día actual
    List<HorarioResult> listadoHorarioCursoDia = listadoHorarioCurso
        .where((horario) =>
            horario.dia.startsWith(_getDiaSemanaString(dia)))
        .toList();

    // Obtener la hora actual y los minutos
    int horaActual = ahora.hour;
    int minutosActual = ahora.minute;

    // Verificar si el alumno está en clase en este momento
    bool alumnoEnClase = false;
    for (int i = 0; i < listadoHorarioCursoDia.length; i++) {
      String horaInicio = listadoHorarioCursoDia[i].hora;
      String horaFin = _calculateEndTime(horaInicio);

      // Parsear la hora de inicio y fin
      int startHour = int.parse(horaInicio.split(":")[0]);
      int startMinute = int.parse(horaInicio.split(":")[1]);
      int endHour = int.parse(horaFin.split(":")[0]);
      int endMinute = int.parse(horaFin.split(":")[1]);

      // Verificar si el alumno está en clase en este momento
      if (horaActual > startHour ||
          (horaActual == startHour && minutosActual >= startMinute)) {
        if (horaActual < endHour ||
            (horaActual == endHour && minutosActual <= endMinute)) {
          asignatura = listadoHorarioCursoDia[i].asignatura;
          aula = listadoHorarioCursoDia[i].aulas;
          alumnoEnClase = true;
          break;
        }
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(listaAlumnos[index].nombre),
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

  String _getDiaSemanaString(int dia) {
    switch (dia) {
      case 1:
        return "L"; // Lunes
      case 2:
        return "M"; // Martes
      case 3:
        return "X"; // Miércoles
      case 4:
        return "J"; // Jueves
      case 5:
        return "V"; // Viernes
      default:
        return ""; // No debería ocurrir si se usa DateTime.now().weekday
    }
  }
}
