import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/splash_screen.dart';
import 'src/views/pantallaprincipal.dart';
import 'src/views/iniciodesesion/iniciarsesion.dart';
import './src/views/doctor/paneldoctor.dart';
import 'src/views/usuario/panelusuario.dart';
import 'src/views/historial/ListaHistorialClinico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Estética',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/pantallaprincipal': (context) => const PantallaPrincipal(),
        '/iniciarsesion': (context) => const IniciarSesion(),
        '/perfildoctor': (context) => const PantallaDoctor(),
        '/panelusuario': (context) => const PantallaUsuario(),
        '/historiales': (context) => const ListaHistorialClinico(),
      },
    );
  }
}
