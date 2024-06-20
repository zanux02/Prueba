import 'package:flutter/material.dart';
import 'package:kk/models/expulsados_response.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MenuExpulsados extends StatelessWidget {
  const MenuExpulsados({Key? key}) : super(key: key);

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
      body: FutureBuilder(
        future: expulsadosProvider.getExpulsados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            expulsados = snapshot.data;
            if (expulsadosProvider.selectedDate != null) {
              expulsados = expulsados.where((expulsado) {
                DateTime fecInic = DateTime.parse(expulsado.fecInic);
                DateTime fecFin = DateTime.parse(expulsado.fecFin);
                DateTime selectedDate = expulsadosProvider.selectedDate!;
                return selectedDate.isAtSameMomentAs(fecInic) ||
                    selectedDate.isAtSameMomentAs(fecFin) ||
                    (selectedDate.isAfter(fecInic) && selectedDate.isBefore(fecFin));
              }).toList();
            }
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context, expulsadosProvider),
                  child: Text(
                    expulsadosProvider.selectedDate == null
                        ? "Seleccionar Fecha"
                        : DateFormat('dd/MM/yyyy').format(expulsadosProvider.selectedDate!.toLocal()),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expulsados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          title: Text(expulsados[index].apellidosNombre),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(expulsados[index].fecInic),
                              const Text(" - "),
                              Text(expulsados[index].fecFin),
                            ],
                          ),
                          subtitle: Text(expulsados[index].curso),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, ExpulsadosProvider expulsadosProvider) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = expulsadosProvider.selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (picked != null && picked != expulsadosProvider.selectedDate) {
      expulsadosProvider.setSelectedDate(picked);
    }
  }
}


class ExpulsadosProvider with ChangeNotifier {
  DateTime? selectedDate;

  // Simulación de obtener los expulsados
  Future<List<Expulsado>> getExpulsados() async {
    // Aquí deberías obtener los datos reales de expulsados
    return [];
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (picked != null && picked != selectedDate) {
      setSelectedDate(picked);
    }
  }
}

class HumanFormats {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
