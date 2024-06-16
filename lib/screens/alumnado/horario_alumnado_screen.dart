import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kk/utils/config.dart';

class HorarioAlumnadoScreen extends StatefulWidget {
  const HorarioAlumnadoScreen({Key? key}) : super(key: key);

  @override
  _HorarioAlumnadoScreenState createState() => _HorarioAlumnadoScreenState();
}

class _HorarioAlumnadoScreenState extends State<HorarioAlumnadoScreen> {
  List<String> listadoCursos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCursos();
  }

  Future<void> _getCursos() async {
    final urlCursos = Config.getCoursesUrl();

    try {
      final response = await http.get(urlCursos);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          listadoCursos = data
              .where((curso) => curso is Map<String, dynamic>)
              .map((curso) => curso['name'] as String)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error fetching courses: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HORARIOS ALUMNOS"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listadoCursos.length,
              itemBuilder: (BuildContext context, int index) {
                String nombreCurso = listadoCursos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "calendario_alumno_screen");
                  },
                  child: ListTile(
                    title: Text(nombreCurso),
                  ),
                );
              },
            ),
    );
  }
}
