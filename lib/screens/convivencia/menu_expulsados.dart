import 'package:flutter/material.dart';
import 'package:kk/models/expulsados_response.dart';
import 'package:kk/providers/expulsados_provider.dart';
import 'package:kk/utils/human_formats.dart';
import 'package:provider/provider.dart';

class MenuExpulsados extends StatefulWidget {
  const MenuExpulsados({Key? key}) : super(key: key);

  @override
  _MenuExpulsadosState createState() => _MenuExpulsadosState();
}

class _MenuExpulsadosState extends State<MenuExpulsados> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expulsadosProvider = Provider.of<ExpulsadosProvider>(context);
    List<Expulsado> expulsados = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expulsados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(HumanFormats.formatDate(selectedDate)),
          ),
          Expanded(
            child: FutureBuilder(
              future: expulsadosProvider.getExpulsados(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  expulsados = snapshot.data ?? [];
                  // Filtrar los expulsados por la fecha seleccionada
                  List<Expulsado> expulsadosFiltrados = expulsados
                      .where((expulsado) =>
                          _isDateInRange(selectedDate, expulsado.fecInic, expulsado.fecFin))
                      .toList();

                  return ListView.builder(
                    itemCount: expulsadosFiltrados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(expulsadosFiltrados[index].apellidosNombre),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(expulsadosFiltrados[index].fecInic),
                            const Text(" - "),
                            Text(expulsadosFiltrados[index].fecFin),
                          ],
                        ),
                        subtitle: Text(expulsadosFiltrados[index].curso),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Error al cargar los datos'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Función para verificar si la fecha seleccionada está dentro del rango de inicio y fin
  bool _isDateInRange(DateTime selectedDate, String fechaInicio, String fechaFin) {
    DateTime start = DateTime.parse(fechaInicio);
    DateTime end = DateTime.parse(fechaFin);

    return selectedDate.isAfter(start.subtract(const Duration(days: 1))) && selectedDate.isBefore(end.add(const Duration(days: 1)));
  }
}
