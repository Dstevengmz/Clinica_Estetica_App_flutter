import 'package:flutter/material.dart';
import 'menuDrawerPerfil.dart';

class PantallaDoctor extends StatelessWidget {
  const PantallaDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final Color fondo = const Color(0xFF0F172A);
    final Color primario = const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuDrawerPerfil(),
      appBar: AppBar(
        title: const Text('Clinica Estetica - rejuvenezk'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.medical_services, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Bienvenido Doctor',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aquí podrás gestionar pacientes, procedimientos, y más.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: primario,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/homeconectado');
              break;
            case 1:
              Navigator.pushNamed(context, '/perfildoctor');
              break;
            case 2:
              Navigator.pushNamed(context, '/perfil');
              break;
            case 3:
              Navigator.pushNamed(context, '/registrar');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Doctor'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Usuario'),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Registrar',
          ),
        ],
      ),
    );
  }
}
