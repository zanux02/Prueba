import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kk/utils/config.dart';

class ContactoAlumnadoScreen extends StatefulWidget {
  const ContactoAlumnadoScreen({Key? key}) : super(key: key);

  @override
  _ContactoAlumnadoScreenState createState() => _ContactoAlumnadoScreenState();
}

class _ContactoAlumnadoScreenState extends State<ContactoAlumnadoScreen> {
  List<String> listadoCursos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCursos();
  }

  Future<void> _fetchCursos() async {
    final urlCursos = Config.getCoursesUrl();

    try {
      final response = await http.get(urlCursos);

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        if (data is List) {
          setState(() {
            listadoCursos = data.map((curso) => curso['name']).toList().cast<String>();
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
        title: const Text("CONTACTO ALUMNOS"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listadoCursos.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(listadoCursos[index]),
                );
              },
            ),
    );
  }
}
