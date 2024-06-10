import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/models/profesor_contacto.dart';
import 'package:kk/utils/config.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactoProfesoresScreen extends StatefulWidget {
  const ContactoProfesoresScreen({Key? key}) : super(key: key);

  @override
  _ContactoProfesoresScreenState createState() =>
      _ContactoProfesoresScreenState();
}

class _ContactoProfesoresScreenState extends State<ContactoProfesoresScreen> {
  List<ProfesorContacto> listaProfesores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfesores();
  }

  Future<void> _fetchProfesores() async {
  final urlProfesores = Uri.parse('${Config.baseUrl}/get/teachers');

  try {
    final response = await http.get(urlProfesores);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('JSON recibido: $jsonResponse');
      
      List<dynamic> data = jsonResponse as List<dynamic>;
      setState(() {
        listaProfesores = data.map((json) => ProfesorContacto.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching teachers: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    debugPrint('Error fetching teachers: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CONTACTO")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaProfesores.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _mostrarAlert(context, index);
                  },
                  child: ListTile(
                    title: Text(
                        '${listaProfesores[index].nombre} ${listaProfesores[index].primerApellido} ${listaProfesores[index].segundoApellido}'),
                  ),
                );
              },
            ),
    );
  }

  void _mostrarAlert(BuildContext context, int index) {
    final profesor = listaProfesores[index];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
              '${profesor.nombre} ${profesor.primerApellido} ${profesor.segundoApellido}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(color: Colors.black, thickness: 1),
              Row(
                children: [
                  Text('Correo: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(profesor.correo),
                  IconButton(
                    onPressed: () {
                      launchUrlString('email:${profesor.correo}');
                    },
                    icon: const Icon(Icons.mail),
                    color: Colors.blue,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Teléfono: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(profesor.telefono ?? 'No disponible'),
                  IconButton(
                    onPressed: profesor.telefono != null
                        ? () {
                            launchUrlString('tel:${profesor.telefono}');
                          }
                        : null,
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
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
