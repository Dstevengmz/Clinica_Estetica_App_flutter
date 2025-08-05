import 'package:flutter/material.dart';
import 'LoginScreen.dart';

class MenuDrawerSinSesion extends StatelessWidget {
  final Color fondo = const Color(0xFF0F172A);
  final Color contenedor = const Color(0xFF1E293B);
  final Color campoTexto = const Color(0xFF334155);
  final Color detalle = const Color(0xFF22C55E);
  final Color texto = const Color(0xFFFFFFFF);
  final Color linkAzul = const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: contenedor,
        foregroundColor: texto,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: const NetworkImage(
                'https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Invitado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.login, color: detalle),
            title: Text("Iniciar sesión", style: TextStyle(color: texto)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.info_outline, color: linkAzul),
            title: Text("Acerca de", style: TextStyle(color: texto)),
            onTap: () {
              // Mostrar información de la app
            },
          ),
        ],
      ),
    );
  }
}
