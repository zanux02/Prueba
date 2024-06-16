import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/utils/config.dart';
import 'package:kk/models/profesor.dart';

class ListadoProfesores extends StatefulWidget {
  const ListadoProfesores({Key? key}) : super(key: key);

  @override
  _ListadoProfesoresState createState() => _ListadoProfesoresState();
}

class _ListadoProfesoresState extends State<ListadoProfesores> {
  List<Profesor> listaProfesores = [];
  Map<String, String> cursosProfesores = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfesores();
  }

  Future<void> _getProfesores() async {
    final urlProfesores = Config.getProfessorsUrl();
    final urlCursos = Config.getCoursesUrl(); 

    try {
      final responseProfesores = await http.get(urlProfesores);
      final responseCursos = await http.get(urlCursos);

      if (responseProfesores.statusCode == 200 && responseCursos.statusCode == 200) {
        List<dynamic> dataProfesores = json.decode(responseProfesores.body);
        List<dynamic> dataCursos = json.decode(responseCursos.body);

        setState(() {
          listaProfesores = dataProfesores.map((json) => Profesor.fromJson(json)).toList();
          _sortProfesoresByName();
          cursosProfesores = {
            for (var curso in dataCursos)
              '${curso['nombreProfesor']} ${curso['primerApellido']} ${curso['segundoApellido']}': curso['nombreAula']
          };
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error fetching data: Profesores: ${responseProfesores.statusCode}, Cursos: ${responseCursos.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching data: $e');
    }
  }

  void _sortProfesoresByName() {
    listaProfesores.sort((a, b) {
      int comparison = a.primerApellido.compareTo(b.primerApellido);
      if (comparison != 0) return comparison;
      comparison = a.segundoApellido.compareTo(b.segundoApellido);
      if (comparison != 0) return comparison;
      return a.nombre.compareTo(b.nombre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROFESORES"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaProfesores.length,
              itemBuilder: (BuildContext context, int index) {
                String nombreProfesor = listaProfesores[index].nombre;
                String primerApellido = listaProfesores[index].primerApellido;
                String segundoApellido = listaProfesores[index].segundoApellido;
                return GestureDetector(
                  onTap: () {
                    _mostrarProfesorEnCurso(context, '$nombreProfesor $primerApellido $segundoApellido');
                  },
                  child: ListTile(
                    title: Text('$nombreProfesor $primerApellido $segundoApellido'),
                  ),
                );
              }),
    );
  }

  void _mostrarProfesorEnCurso(BuildContext context, String nombreCompletoProfesor) {
    String curso = cursosProfesores[nombreCompletoProfesor] ?? 'No se encuentra disponible';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text(nombreCompletoProfesor),
          content: Text(curso),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
