import 'package:flutter/material.dart';
import '../../widgets/menulateral.dart';

class PantallaDoctor extends StatelessWidget {
  const PantallaDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final Color fondo = const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuLateral(
        nombreUsuario: 'Doctor',
        rol: 'DOCTOR',
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/iniciarsesion');
        },
      ),
      appBar: AppBar(
        title: const Text('Clinica Estetica'),
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
    );
  }
}
