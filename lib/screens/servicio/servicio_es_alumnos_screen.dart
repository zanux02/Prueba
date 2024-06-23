import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iJandula/providers/servicio_provider.dart';

class ServicioESAlumnosScreen extends StatelessWidget {
  const ServicioESAlumnosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerNombreAlumno = TextEditingController();
    final TextEditingController controllerFechaEntrada = TextEditingController();
    final TextEditingController controllerFechaSalida = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ServicioESAlumnos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controllerNombreAlumno,
                decoration: const InputDecoration(labelText: 'Nombre del alumno'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: controllerFechaEntrada,
                decoration: const InputDecoration(labelText: 'Fecha de entrada'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null)
                    controllerFechaEntrada.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                },
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: controllerFechaSalida,
                decoration: const InputDecoration(labelText: 'Fecha de salida'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null)
                    controllerFechaSalida.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Obtener los valores de los controladores
                  String nombreAlumno = controllerNombreAlumno.text;
                  String fechaEntrada = controllerFechaEntrada.text;
                  String fechaSalida = controllerFechaSalida.text;

                  // Validar que los campos no estén vacíos
                  if (nombreAlumno.isNotEmpty && fechaEntrada.isNotEmpty && fechaSalida.isNotEmpty) {
                    // Obtener el provider y enviar los datos
                    Provider.of<ServicioProvider>(context, listen: false)
                        .setAlumnosServicio(nombreAlumno, fechaEntrada, fechaSalida);
                  } else {
                    // Mostrar mensaje de error si falta algún campo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor completa todos los campos'),
                      ),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
