import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iJandula/models/servicio_response.dart';
import 'package:iJandula/providers/servicio_provider.dart';

class ServicioInformesScreen extends StatefulWidget {
  const ServicioInformesScreen({Key? key}) : super(key: key);

  @override
  State<ServicioInformesScreen> createState() => _ServicioInformesScreenState();
}

class _ServicioInformesScreenState extends State<ServicioInformesScreen> {
  String selectedDateInicio = "";
  String selectedDateFin = "";
  List<Servicio> listaAlumnosFechas = [];
  List<String> listaAlumnosNombres = [];
  DateTime dateTimeInicio = DateTime.now();
  DateTime dateTimeFin = DateTime.now();
  int size = 0;

  @override
  Widget build(BuildContext context) {
    double anchura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("INFORMES"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: anchura * 0.5,
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        controller:
                            TextEditingController(text: selectedDateInicio),
                        decoration: InputDecoration(
                          labelText: "FECHA INICIO",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            onPressed: () {
                              _selectDate(context, "Inicio");
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: anchura * 0.5,
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        controller:
                            TextEditingController(text: selectedDateFin),
                        decoration: InputDecoration(
                          labelText: "FECHA FIN",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            onPressed: () => _selectDate(context, "Fin"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        listaAlumnosFechas = [];
                        listaAlumnosNombres = [];
                        updateLista(context, dateTimeInicio, dateTimeFin);

                        for (int i = 0; i < listaAlumnosFechas.length; i++) {
                          listaAlumnosNombres
                              .add(listaAlumnosFechas[i].nombreAlumno);
                        }

                        listaAlumnosNombres =
                            listaAlumnosNombres.toSet().toList();

                        listaAlumnosNombres.sort((a, b) => a.compareTo(b));
                        size = listaAlumnosNombres.length;
                      });
                    },
                    child: const Text("MOSTRAR"))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: size,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, "servicio_informes_detalles_screen",
                      arguments: listaAlumnosNombres[index]),
                  child: ListTile(
                    title: Text(listaAlumnosNombres[index]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String mode) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
      setState(() {
        if (mode == "Inicio") {
          selectedDateInicio = formattedDate;
          dateTimeInicio = pickedDate;
        } else {
          selectedDateFin = formattedDate;
          dateTimeFin = pickedDate;
        }
      });
    }
  }

  void updateLista(
      BuildContext context, DateTime dateTimeInicio, DateTime dateTimeFin) {
    final servicioProviderLista =
        Provider.of<ServicioProvider>(context, listen: false);
    final listadoAlumnadoServicio =
        servicioProviderLista.listadoAlumnosServicio;

    for (int i = 0; i < listadoAlumnadoServicio.length; i++) {
      bool dentro = compararFechas(
          listadoAlumnadoServicio[i], dateTimeInicio, dateTimeFin);

      if (dentro) {
        listaAlumnosFechas.add(listadoAlumnadoServicio[i]);
      }
    }
  }

  bool compararFechas(
      Servicio listadoAlumnadoServicio, DateTime dateInicio, DateTime dateFin) {
    DateTime fechaSalida = DateTime.parse(listadoAlumnadoServicio.fechaSalida);
    
    if (fechaSalida.isAfter(dateInicio.subtract(const Duration(days: 1))) &&
        fechaSalida.isBefore(dateFin.add(const Duration(days: 1)))) {
      return true;
    }

    return false;
  }
}
