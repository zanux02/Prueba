import 'package:flutter/material.dart';
import 'package:kk/models/expulsados_response.dart';
import 'package:kk/providers/expulsados_provider.dart';
import 'package:kk/utils/human_formats.dart';
import 'package:kk/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class MenuExpulsados extends StatelessWidget {
  const MenuExpulsados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expulsadosProvider = Provider.of<ExpulsadosProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expulsados'),
      ),
      body: FutureBuilder(
        future: expulsadosProvider.getExpulsados(),
        builder: (BuildContext context, AsyncSnapshot<List<Expulsado>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Expulsado> expulsados = snapshot.data!;
              List<Expulsado> filteredExpulsados = expulsados.where((expulsado) {
                DateTime selectedDate = expulsadosProvider.selectedDate.toLocal();
                DateTime fecInic = DateTime.parse(expulsado.fecInic);
                DateTime fecFin = DateTime.parse(expulsado.fecFin);
                return selectedDate.isAfter(fecInic) && selectedDate.isBefore(fecFin.add(const Duration(days: 1)));
              }).toList();

              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await expulsadosProvider.selectDate(context);
                    },
                    child: Text(HumanFormats.formatDate(expulsadosProvider.selectedDate.toLocal())),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredExpulsados.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            //_mostrarAlert(context, index, listadoExpulsadosHoy,
                            //    cogerDatosExpulsados);
                          },
                          child: ListTile(
                            title: Text(filteredExpulsados[index].apellidosNombre),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(filteredExpulsados[index].fecInic),
                                const Text(" - "),
                                Text(filteredExpulsados[index].fecFin),
                              ],
                            ),
                            subtitle: Text(filteredExpulsados[index].curso),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: const SideMenu(),
    );
  }
}
