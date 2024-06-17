import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kk/firebase_options.dart';
import 'package:kk/providers/expulsados_provider.dart';
import 'package:kk/providers/providers.dart';
import 'package:kk/screens/alumnado/alumnado_screen.dart';
import 'package:kk/screens/alumnado/contacto_alumnado_screen.dart';
import 'package:kk/screens/alumnado/contacto_detalles_alumnado_screen.dart';
import 'package:kk/screens/alumnado/horario_alumnado_screen.dart';
import 'package:kk/screens/alumnado/horario_detalles_alumnado_screen.dart';
import 'package:kk/screens/alumnado/localizacion_alumnado_screen.dart';
import 'package:kk/screens/convivencia/convivencia_screen.dart';
import 'package:kk/screens/convivencia/expulsados_screen.dart';
import 'package:kk/screens/convivencia/incidencia_telefono_screen.dart';
import 'package:kk/screens/convivencia/mayores_screen.dart';
import 'package:kk/screens/convivencia/reflexion_screen.dart';
import 'package:kk/screens/convivencia/screen_expulsados.dart';
import 'package:kk/screens/convivencia/comportamiento_alumno_screen.dart';
import 'package:kk/screens/convivencia/carnet_screen.dart';
import 'package:kk/screens/dace/dace_screen.dart';
import 'package:kk/screens/interfaz/home_screen.dart';
import 'package:kk/screens/interfaz/login_screen.dart';
import 'package:kk/screens/interfaz/main_screen.dart';
import 'package:kk/screens/profesores/contacto_profesores_screen.dart';
import 'package:kk/screens/profesores/horario_profesores_detalles_screen.dart';
import 'package:kk/screens/profesores/horario_profesores_screen.dart';
import 'package:kk/screens/profesores/listado_profesores.dart';
import 'package:kk/screens/profesores/personal_screen.dart';
import 'package:kk/screens/screens.dart';
import 'package:kk/service/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  logOut();

  runApp(const AppState());
}

void logOut() async {
  FirebaseService service = FirebaseService();
  try {
    await service.signOutFromGoogle();
  } catch (e) {
    if (e is FirebaseAuthException) {
      debugPrint(e.message!);
    }
  }
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CredencialesProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ConvivenciaProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ServicioProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AlumnadoProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CentroProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DaceProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ExpulsadosProvider(),
          lazy: false,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const LoginScreen(),
        "home_screen": (BuildContext context) => const HomeScreen(),
        "main_screen": (BuildContext context) => const MainScreen(),
        "convivencia_screen": (BuildContext context) => const ConvivenciaScreen(),
        "expulsados_screen": (BuildContext context) => const ExpulsadosScreen(),
        "screen_expulsados": (BuildContext context) => const ScreenExpulsados(),
        "mayores_screen": (BuildContext context) => const MayoresScreen(),
        "dace_screen": (BuildContext context) => const DaceScreen(),
        "personal_screen": (BuildContext context) => const PersonalScreen(),
        "listado_profesores_screen": (BuildContext context) =>
            const ListadoProfesores(),
        "contacto_profesores_screen": (BuildContext context) =>
            const ContactoProfesoresScreen(),
        "horario_profesores_screen": (BuildContext context) =>
            const HorarioProfesoresScreen(),
        "horario_profesores_detalles_screen": (BuildContext context) =>
            const HorarioProfesoresDetallesScreen(),
        "alumnado_screen": (BuildContext context) => const AlumnadoScreen(),
        "contacto_alumnado_screen": (BuildContext context) =>
            const ContactoAlumnadoScreen(),
        "localizacion_alumnado_screen": (BuildContext context) =>
            const LocalizacionAlumnadoScreen(),
        "horario_alumnado_screen": (BuildContext context) =>
            const HorarioAlumnadoScreen(),
        "horario_detalles_alumnado_screen": (BuildContext context) =>
            const HorarioDetallesAlumnadoScreen(),
        "contacto_detalles_alumnado_screen": (BuildContext context) =>
            const ContactoDetallesAlumnadoScreen(),
        "servicio_screen": (BuildContext context) => const ServicioScreen(),
        "servicio_es_screen": (BuildContext context) => const ServicioESScreen(),
        "servicio_es_alumnos_screen": (BuildContext context) =>
            const ServicioESAlumnosScreen(),
        "servicio_informes_screen": (BuildContext context) =>
            const ServicioInformesScreen(),
        "servicio_informes_detalles_screen": (BuildContext context) =>
            const ServicioInformesDetallesScreen(),
        "comportamiento_alumno_screen": (BuildContext context) =>
            const ComportamientoAlumnoScreen(),
        "reflexion_screen": (BuildContext context) =>
            const ReflexionScreen(),
        "carnet_screen": (BuildContext context) =>
            const CardScreen(),
        "incidencia_telefono_screen": (BuildContext context) =>
            const IncidenciaTelefonoScreen(),
      },
    );
  }
}
