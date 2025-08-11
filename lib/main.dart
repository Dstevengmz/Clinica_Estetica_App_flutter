import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/views/splash_screen.dart';
import 'src/views/PantallaLoginview.dart';
import 'src/views/RegistrarUsuarioView.dart';
import 'src/views/MenuPrincipalview.dart';
import 'src/views/DashboardDoctorview.dart';
import 'src/views/MenuPrincipalConectadoView.dart';

void main() async {
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
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistrarUsuario(),
        'perfildoctor': (context) => const PantallaDoctor(),
        '/home': (context) => MenuPrincipalSesion(),
        '/homeconectado': (context) => MenuPrincipalConectadoSesion(),
      },
    );
  }
}
