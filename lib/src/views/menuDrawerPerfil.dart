import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PantallaLoginview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MenuDrawerPerfil extends StatefulWidget {
  @override
  _MenuDrawerPerfilState createState() => _MenuDrawerPerfilState();
}

class _MenuDrawerPerfilState extends State<MenuDrawerPerfil> {
  // 🎨 Paleta
  final Color fondo = const Color(0xFF0F172A);
  final Color contenedor = const Color(0xFF1E293B);
  final Color campoTexto = const Color(0xFF334155);
  final Color detalle = const Color(0xFF22C55E);
  final Color texto = const Color(0xFFFFFFFF);
  final Color linkAzul = const Color(0xFF3B82F6);

  // Variables de usuario
  String nombre = '';
  String correo = '';
  String rol = '';
  String numerodocumento = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? 'Nombre no disponible';
      correo = prefs.getString('correo') ?? 'Correo no disponible';
      rol = prefs.getString('rol') ?? 'Sin rol';
      numerodocumento = prefs.getString('numerodocumento') ?? 'No registrado';
    });
  }

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
            child: Column(
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  correo,
                  style: TextStyle(fontSize: 16, color: texto.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.badge, color: detalle),
            title: Text("Rol", style: TextStyle(color: texto)),
            subtitle: Text(
              rol,
              style: TextStyle(color: texto.withOpacity(0.6)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.credit_card, color: detalle),
            title: Text("C.C.", style: TextStyle(color: texto)),
            subtitle: Text(
              numerodocumento,
              style: TextStyle(color: texto.withOpacity(0.6)),
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.lock, color: detalle),
            title: Text("Cambiar Contraseña", style: TextStyle(color: texto)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Función aún no disponible")),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.settings, color: detalle),
            title: Text("Ajustes", style: TextStyle(color: texto)),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text("Cerrar sesión", style: TextStyle(color: texto)),
            onTap: () {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "¿Estás seguro de que deseas cerrar sesión?",
                desc: "¡No podrás revertir esto!",
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.grey,
                  ),
                  DialogButton(
                    child: const Text(
                      "Cerrar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pop(context);

                      Alert alert = Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Sesión cerrada",
                        desc: "Has cerrado sesión correctamente.",
                        buttons: [],
                      );

                      alert.show();

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      });
                    },
                    color: Colors.redAccent,
                  ),
                ],
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
