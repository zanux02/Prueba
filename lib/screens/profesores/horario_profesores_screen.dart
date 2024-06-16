import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/utils/config.dart';

class HorarioProfesoresScreen extends StatefulWidget {
  const HorarioProfesoresScreen({Key? key}) : super(key: key);

  @override
  _HorarioProfesoresScreenState createState() =>
      _HorarioProfesoresScreenState();
}

class _HorarioProfesoresScreenState extends State<HorarioProfesoresScreen> {
  List<dynamic> listadoProfesores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfesores();
  }

  Future<void> _getProfesores() async {
    final url = Config.getProfessorsUrl();

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          listadoProfesores = json.decode(response.body);
          _sortProfesoresByName();
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

  void _sortProfesoresByName() {
    listadoProfesores.sort((a, b) {
      final fullNameA =
          '${a['primerApellido']} ${a['segundoApellido']} ${a['nombre']}';
      final fullNameB =
          '${b['primerApellido']} ${b['segundoApellido']} ${b['nombre']}';
      return fullNameA.compareTo(fullNameB);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HORARIO"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listadoProfesores.length,
              itemBuilder: (BuildContext context, int index) {
                final profesor = listadoProfesores[index];
                final nombre = profesor['nombre'];
                final primerApellido = profesor['primerApellido'];
                final segundoApellido = profesor['segundoApellido'];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, "horario_profesores_detalles_screen",
                        arguments: index);
                  },
                  child: ListTile(
                    title: Text('$nombre $primerApellido $segundoApellido'),
                  ),
                );
              },
            ),
    );
  }
}
