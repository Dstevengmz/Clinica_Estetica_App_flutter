import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuPrincipalview.dart';
import 'DashboardDoctorview.dart';
import 'DashboardUsuarioview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _verificarTokenYRedirigir();
  }

  void _verificarTokenYRedirigir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    String? rol = prefs.getString('rol');

    await Future.delayed(const Duration(seconds: 3));

    if (token != null && token.isNotEmpty) {
      if (rol == 'doctor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PantallaDoctor()),
        );
      } else if (rol == 'usuario') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PantallaUsuario()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MenuPrincipalSesion()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuPrincipalSesion()),
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
