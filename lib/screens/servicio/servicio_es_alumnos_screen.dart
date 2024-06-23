import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iJandula/models/models.dart';
import 'package:iJandula/providers/providers.dart';

class ServicioESAlumnosScreen extends StatefulWidget {
  const ServicioESAlumnosScreen({Key? key}) : super(key: key);

  @override
  State<ServicioESAlumnosScreen> createState() => _ServicioESAlumnosScreenState();
}

class _ServicioESAlumnosScreenState extends State<ServicioESAlumnosScreen> {
  bool botonPulsado = true;
  bool fechaCompleta = false;
  String fechaFormatoEntrada = "";
  String fechaFormatoSalida = "";
  String nombreAlumno = "";
  final controllerTextoNombreAlumno = TextEditingController();
  final controllerTextoFechaEntrada = TextEditingController();
  final controllerTextoFechaSalida = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;
    final nombreCurso = ModalRoute.of(context)!.settings.arguments;

    List<DatosAlumnos> listaAlumnos = [];

    for (int i = 0; i < listadoAlumnos.length; i++) {
      if (listadoAlumnos[i].curso == nombreCurso) {
        listaAlumnos.add(listadoAlumnos[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$nombreCurso"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listaAlumnos.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                controllerTextoNombreAlumno.text = "";
                controllerTextoFechaEntrada.text = "";
                controllerTextoFechaSalida.text = "";

                showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    controllerTextoNombreAlumno.text = listaAlumnos[index].nombre;

                    controllerTextoFechaEntrada.text = DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());
                    return dialogoBotones(
                      fechaCompleta,
                      controllerTextoNombreAlumno,
                      controllerTextoFechaEntrada,
                      controllerTextoFechaSalida,
                    );
                  },
                );
              },
              child: ListTile(
                title: Text(
                  listaAlumnos[index].nombre,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dialogoBotones(
    bool fechaCompleta,
    TextEditingController controllerTextoNombreAlumno,
    TextEditingController controllerTextoFechaEntrada,
    TextEditingController controllerTextoFechaSalida,
  ) {
    final servicioProvider = Provider.of<ServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "CANCELAR",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 90,
        actions: [
          TextButton(
            onPressed: () {
                // Separar fecha y hora de entrada
                var fechaHoraEntrada = controllerTextoFechaEntrada.text.split(" ");
                String fechaEntrada = fechaHoraEntrada[0].replaceAll("-", "/"); // Reemplazar guiones por barras
                String horaEntrada = fechaHoraEntrada[1];

                // Separar fecha y hora de salida
                var fechaHoraSalida = controllerTextoFechaSalida.text.split(" ");
                String fechaSalida = fechaHoraSalida[0].replaceAll("-", "/"); // Reemplazar guiones por barras
                String horaSalida = fechaHoraSalida[1];

                servicioProvider.setAlumnosServicio(
                  controllerTextoNombreAlumno.text,
                  fechaEntrada,
                  horaEntrada,
                  fechaSalida,
                  horaSalida,
                );
                Navigator.pop(context);
              },
            child: const Text(
              "CONFIRMAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: controllerTextoNombreAlumno,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "NOMBRE ALUMNO",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: false,
              ),
              const Divider(color: Colors.transparent),
              TextField(
                controller: controllerTextoFechaEntrada,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "FECHA ENTRADA",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: false,
              ),
              const Divider(color: Colors.transparent),
              TextField(
                controller: controllerTextoFechaSalida,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        fechaCompleta = true;
                        controllerTextoFechaSalida.text = DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());
                      });
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      size: 30,
                    ),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "FECHA SALIDA",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
