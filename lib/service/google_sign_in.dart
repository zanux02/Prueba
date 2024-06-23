// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:iJandula/providers/credenciales_provider.dart';
import 'package:iJandula/service/firebase_service.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({Key? key}) : super(key: key);

  @override
  GoogleSignInState createState() => GoogleSignInState();
}

class GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final credencialesProvider = Provider.of<CredencialesProvider>(context);


    Size size = MediaQuery.of(context).size;

    return !isLoading
        ? Container(
            margin: const EdgeInsets.only(top: 15),
            width: size.width * 0.85,
            height: 55,
            child: OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.google),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  // Llamar al método para cargar credenciales periódicamente
                  await cargarCredencialesPeriodicamente(credencialesProvider);

                  // Volver a obtener la lista actualizada después de la carga de datos
                  final listaActualizada = credencialesProvider.listaCredenciales;

                  FirebaseService service = FirebaseService();
                  await service.signInWithGoogle();

                  User? user = FirebaseAuth.instance.currentUser;
                  String? usuarioGoogle = user?.email;
                  String? nombreUsuarioGoogle = user?.displayName;

                  if (usuarioGoogle == null) {
                    _mostrarError(context, "No se pudo obtener el usuario de Google.");
                    return;
                  }

                  bool existe = false;

                  // Iterar sobre la lista actualizada solo si no está vacía
                  if (listaActualizada.isNotEmpty) {
                    for (int i = 0; i < listaActualizada.length; i++) {
                      debugPrint(listaActualizada[i].usuario);
                      if (listaActualizada[i].usuario == usuarioGoogle) {
                        existe = true;
                        Navigator.pushNamed(context, "main_screen",
                            arguments: nombreUsuarioGoogle);
                        break;
                      }
                    }
                  } else {
                    _mostrarError(context, "No se pudieron cargar las credenciales.");
                  }

                  if (!existe) {
                    _mostrarAlert(context);
                    logOut();
                  }
                } catch (e) {
                  _mostrarError(context, "Error al iniciar sesión con Google: $e");
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              label: const Text(
                "Accede a tu cuenta de Google",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.all(15),
            child: const CircularProgressIndicator(),
          );
  }

  Future<void> cargarCredencialesPeriodicamente(CredencialesProvider credencialesProvider) async {
    while (credencialesProvider.listaCredenciales.isEmpty) {
      await credencialesProvider.getCredencialesUsuario();
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  void _mostrarAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text("Error en la verificación"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("No existe ninguna cuenta con esas credenciales"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarError(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
