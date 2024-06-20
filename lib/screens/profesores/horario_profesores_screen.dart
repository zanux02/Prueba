import 'package:flutter/material.dart';
import 'package:kk/models/profesor_response.dart';
import 'package:kk/providers/profesor_provider.dart';
import 'package:provider/provider.dart';

class HorarioProfesoresScreen extends StatelessWidget {
  const HorarioProfesoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesorProvider>(context);
    List<ProfesorRes> listadoProfesores = profesorProvider.listadoProfesor;

    // Ordenar la lista por nombre
    listadoProfesores.sort((a, b) => a.nombre.compareTo(b.nombre));

    return Scaffold(
      appBar: AppBar(
        title: const Text("HORARIO"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listadoProfesores.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  null;
                },
                child: Container(),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context, "horario_profesores_detalles_screen",
                    arguments: index,
                  );
                },
                child: ListTile(
                  title: Text(
                    '${listadoProfesores[index].nombre} ${listadoProfesores[index].apellidos}',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
