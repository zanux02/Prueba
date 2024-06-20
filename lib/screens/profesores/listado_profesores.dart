import 'package:flutter/material.dart';
import 'package:kk/models/profesor_response.dart';
import 'package:provider/provider.dart';
import 'package:kk/providers/profesor_provider.dart';

class ListadoProfesores extends StatelessWidget {
  const ListadoProfesores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesorProvider>(context);
    final listadoProfesores = profesorProvider.listadoProfesor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LISTA PROFESORES"),
      ),
      body: ListView.builder(
        itemCount: listadoProfesores.length,
        itemBuilder: (BuildContext context, int index) {
          final profesor = listadoProfesores[index];
          final nombreProfesor = profesor.nombre;
          final apellidoProfesor = profesor.apellidos;

          return ListTile(
            title: Text("$nombreProfesor $apellidoProfesor"),
            onTap: () {
              _mostrarLocalizacion(context, profesor);
            },
          );
        },
      ),
    );
  }

  void _mostrarLocalizacion(BuildContext context, ProfesorRes profesor) {
    final profesorProvider = Provider.of<ProfesorProvider>(context, listen: false);
    final listadoHorarios = profesorProvider.listadoHorarios;

    final horarioProfesor = listadoHorarios.firstWhere(
      (horario) =>
          horario.nombreProfesor == profesor.nombre &&
          horario.apellidoProfesor == profesor.apellidos,
    );

    if (horarioProfesor != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("${profesor.nombre} ${profesor.apellidos}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Curso: ${horarioProfesor.curso}"),
                Text("Asignatura: ${horarioProfesor.asignatura}"),
                Text("Hora: ${horarioProfesor.hora}"),
                Text("Aula: ${horarioProfesor.aulas}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("${profesor.nombre} ${profesor.apellidos}"),
            content: const Text("No se encontraron horarios para este profesor."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
