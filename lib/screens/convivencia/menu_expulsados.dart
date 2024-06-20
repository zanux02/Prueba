import 'package:flutter/material.dart';
import 'package:kk/models/expulsados_response.dart';
import 'package:kk/providers/expulsados_provider.dart';
import 'package:kk/utils/human_formats.dart';
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
                DateTime fecInic = HumanFormats.formatStringToDate(expulsado.fecInic);
                DateTime fecFin = HumanFormats.formatStringToDate(expulsado.fecFin);
                DateTime selectedDate = expulsadosProvider.selectedDate;
                return selectedDate.isAtSameMomentAs(fecInic) ||
                    selectedDate.isAtSameMomentAs(fecFin) ||
                    (selectedDate.isAfter(fecInic) && selectedDate.isBefore(fecFin));
              }).toList();
            }

            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => expulsadosProvider.selectDate(context),
                  child: Text(
                    expulsadosProvider.selectedDate == null
                        ? "Seleccionar Fecha"
                        : DateFormat('dd/MM/yyyy').format(expulsadosProvider.selectedDate.toLocal()),
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
}
