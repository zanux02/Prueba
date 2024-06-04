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
    List<Expulsado> expulsados = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expulsados'),
      ),
      body: FutureBuilder(
        future: expulsadosProvider.getExpulsados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            expulsados = snapshot.data;
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => expulsadosProvider.selectDate(context),
                  child: Text(HumanFormats.formatDate(
                    expulsadosProvider.selectedDate.toLocal())),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expulsados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          //_mostrarAlert(context, index, listadoExpulsadosHoy,
                          //    cogerDatosExpulsados);
                        },
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
      drawer: const SideMenu(),
    );
  }
}