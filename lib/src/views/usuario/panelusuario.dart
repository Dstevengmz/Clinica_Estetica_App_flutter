import 'package:flutter/material.dart';
import '../../widgets/menulateral.dart';

class PantallaUsuario extends StatelessWidget {
  const PantallaUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final Color fondo = const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuLateral(
        nombreUsuario: 'Usuario',
        rol: 'USUARIO',
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/iniciarsesion');
        },
      ),
      appBar: AppBar(
        title: const Text('Clinica Estetica'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person, size: 80, color: Colors.purple),
            SizedBox(height: 20),
            Text(
              'Bienvenido Usuario',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aquí podrás ver tus citas, tratamientos, y más.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
