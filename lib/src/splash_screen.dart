import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/pantallaprincipal.dart';
import 'views/iniciodesesion/iniciarsesion.dart';
import 'views/usuario/panelusuario.dart';
import 'views/doctor/paneldoctor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decidirNavegacion();
  }

  Future<void> _decidirNavegacion() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final rol = prefs.getString('rol');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      final r = (rol ?? '').toUpperCase();
      Widget destino;
      if (r == 'DOCTOR') {
        destino = const PantallaDoctor();
      } else if (r == 'USUARIO' || r == 'CLIENTE') {
        destino = const PantallaUsuario();
      } else {
        destino = PantallaPrincipal(rol: rol);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destino),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IniciarSesion()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 18, 62, 95),
              Color.fromARGB(255, 235, 235, 238),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: const Center(
          child: Text(
            "clinica estetica",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
