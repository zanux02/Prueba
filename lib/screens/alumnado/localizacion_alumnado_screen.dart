import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/utils/config.dart';
import 'package:kk/models/datos_alumnos.dart';

class LocalizacionAlumnadoScreen extends StatefulWidget {
  const LocalizacionAlumnadoScreen({Key? key}) : super(key: key);

  @override
  _LocalizacionAlumnadoScreenState createState() => _LocalizacionAlumnadoScreenState();
}

class _LocalizacionAlumnadoScreenState extends State<LocalizacionAlumnadoScreen> {
  List<DatosAlumnos> listaOrdenada = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
  }

  Future<void> _fetchAlumnos() async {
    final urlEstudiantes = Uri.parse('${Config.baseUrl}/get/sortstudents');

    try {
      final response = await http.get(urlEstudiantes);

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        if (data is List) {
          setState(() {
            listaOrdenada = data.map((json) => DatosAlumnos.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          debugPrint('Error: Expected a list but got ${data.runtimeType}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error fetching students: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LOCALIZACION ALUMNOS")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaOrdenada.length,
              itemBuilder: (BuildContext context, int index) {
                String nombreAlumno = listaOrdenada[index].nombre;
                return ListTile(
                  title: Text(nombreAlumno),
                );
              },
            ),
    );
  }
}
