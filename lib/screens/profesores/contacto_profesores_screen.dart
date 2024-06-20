
import 'package:flutter/material.dart';
import 'package:kk/models/profesor_response.dart';
import 'package:provider/provider.dart';
import 'package:kk/providers/profesor_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactoProfesoresScreen extends StatelessWidget {
  const ContactoProfesoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesorProvider>(context);
    final listadoProfesores = profesorProvider.listadoProfesor;

    // Ordenar la lista de profesores por nombre
    List<ProfesorRes> listaOrdenadaProfesores = [];
    listaOrdenadaProfesores.addAll(listadoProfesores);
    listaOrdenadaProfesores.sort(((a, b) => a.nombre.compareTo(b.nombre)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("CONTACTO"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listaOrdenadaProfesores.length,
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
                  _mostrarAlert(context, index, listaOrdenadaProfesores);
                },
                child: ListTile(
                  title: Text(
                    '${listaOrdenadaProfesores[index].nombre} ${listaOrdenadaProfesores[index].apellidos}',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index, List<ProfesorRes> listadoProfesores) {
    final profesor = listadoProfesores[index];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        TextStyle textStyle = const TextStyle(fontWeight: FontWeight.bold);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('${profesor.nombre} ${profesor.apellidos}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Row(
                children: [
                  Text(
                    "Correo: ",
                    style: textStyle,
                  ),
                  Expanded(
                    child: Text(profesor.usuario),
                  ),
                  IconButton(
                    onPressed: () {
                      launchUrlString("mailto:${profesor.usuario}");
                    },
                    icon: const Icon(Icons.mail),
                    color: Colors.blue,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Teléfono: ",
                    style: textStyle,
                  ),
                  Expanded(
                    child: Text(profesor.telefono),
                  ),
                  IconButton(
                    onPressed: () {
                      launchUrlString("tel:${profesor.telefono}");
                    },
                    icon: const Icon(Icons.phone),
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
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
}
