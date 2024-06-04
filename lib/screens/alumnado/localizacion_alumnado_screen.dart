import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/utils/config.dart';

class LocalizacionAlumnadoScreen extends StatefulWidget {
  const LocalizacionAlumnadoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacionAlumnadoScreen> createState() => _LocalizacionAlumnadoScreenState();
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
        List<dynamic> data = json.decode(response.body);
        setState(() {
          listaOrdenada = data.map((json) => DatosAlumnos.fromJson(json)).toList();
          isLoading = false;
        });
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
                return GestureDetector(
                  onTap: () {
                    _mostrarAlert(context, index);
                  },
                  child: ListTile(
                    title: Text(listaOrdenada[index].nombre),
                  ),
                );
              },
            ),
    );
  }

  void _mostrarAlert(BuildContext context, int index) {
    // Aquí puedes implementar la lógica para mostrar la alerta con la información del alumno
    // Puedes acceder a la información del alumno seleccionado utilizando listaOrdenada[index]
  }
}

class DatosAlumnos {
  final String nombre;
  final String curso;

  DatosAlumnos({required this.nombre, required this.curso});

  factory DatosAlumnos.fromJson(Map<String, dynamic> json) {
    return DatosAlumnos(
      nombre: json['nombre'],
      curso: json['curso'],
    );
  }
}
