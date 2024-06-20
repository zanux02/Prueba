import 'package:flutter/material.dart';
import 'package:kk/providers/alumnado_provider.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';

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
              _mostrarAlert(
                  context, index, listaOrdenada[index], listadoHorarios);
            },
            child: ListTile(
              title: Text(listaOrdenada[index].nombre),
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index, DatosAlumnos alumno,
      List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();
    int horaActual = ahora.hour;

    // Filtrar los horarios del alumno actual
    List<HorarioResult> horariosAlumno = listadoHorarios.where((horario) =>
            horario.curso == alumno.curso && horario.dia == ahora.weekday.toString())
        .toList();

    String asignatura = "";
    String aula = "";
    String texto = "";

    // Iterar sobre los horarios del alumno actual
    for (int i = 0; i < horariosAlumno.length; i++) {
      String horaInicio = horariosAlumno[i].hora;
      String horaFin = sumarHora(horaInicio);

      // Convertir horas a enteros para la comparación
      int horaInicioInt = int.parse(horaInicio.split(":")[0]);
      int minutoInicioInt = int.parse(horaInicio.split(":")[1]);
      int horaFinInt = int.parse(horaFin.split(":")[0]);
      int minutoFinInt = int.parse(horaFin.split(":")[1]);

      // Verificar si la hora actual está dentro del rango de la clase
      if ((horaActual > horaInicioInt ||
              (horaActual == horaInicioInt && ahora.minute >= minutoInicioInt)) &&
          (horaActual < horaFinInt ||
              (horaActual == horaFinInt && ahora.minute < minutoFinInt))) {
        asignatura = horariosAlumno[i].asignatura;
        aula = horariosAlumno[i].aulas;
        break; // Se encontró la clase, salir del bucle
      }
    }

    // Construir el mensaje a mostrar en el AlertDialog
    if (aula.isEmpty || asignatura.isEmpty) {
      texto = "El alumno no está disponible en este momento";
    } else {
      texto =
          "El alumno ${alumno.nombre} se encuentra actualmente en el aula $aula, en la asignatura $asignatura";
    }

    // Mostrar el AlertDialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(alumno.nombre),
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

    // Asegurar que los minutos no superen 59
    minutos = minutos % 60;

    // Formatear los minutos a dos dígitos
    String minutosString = minutos.toString().padLeft(2, '0');

    return "$horas:$minutosString";
  }
}
