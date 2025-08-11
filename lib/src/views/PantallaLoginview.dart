import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/IniciarSesionUsuarioService.dart';
import 'MenuPrincipalSesion.dart';
import '../views/RegistrarUsuarioView.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool _cargando = false;

  final Color fondoOscuro = const Color(0xFF1B2430);
  final Color cajaFormulario = const Color(0xFF222E3C);
  final Color campos = const Color(0xFF2E3A4B);
  final Color textoClaro = Colors.white70;

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      Alert(
        context: context,
        type: AlertType.info,
        title: "Hay Campos vacios",
        desc: "Completar todos los campos obligatorios.",
        buttons: [
          DialogButton(
            child: const Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
            color: Colors.blue,
          ),
        ],
      ).show();
      return; // Detener el login
    }

    setState(() => _cargando = true);

    final response = await loginUsuario(
      correoController.text.trim(),
      contrasenaController.text.trim(),
    );

    setState(() => _cargando = false);

    if (response != null) {
      final String token = response['token'];
      final String rol = response['usuario']['rol'];
      final String nombre = response['usuario']['nombre'] ?? '';
      final String correo = response['usuario']['correo'] ?? '';
      final String numerodocumento =
          response['usuario']['numerodocumento']?.toString() ?? '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('rol', rol);
      await prefs.setString('nombre', nombre);
      await prefs.setString('correo', correo);
      await prefs.setString('numerodocumento', numerodocumento);

      print('Token guardado');
      print('Rol guardado');
      print('Nombre guardado');
      print('Correo guardado');
      print('Documento guardado');

      if (!mounted) return;

      Alert alert = Alert(
        context: context,
        type: AlertType.success,
        title: "Bienvenido",
        desc: "Inicio de sesión exitoso",
        buttons: [],
      );
      alert.show();
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPrincipalSesion(rol: rol),
          ),
        );
      });
    } else {
      if (!mounted) return;

      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Correo o contraseña incorrectos",
        buttons: [
          DialogButton(
            child: const Text(
              "Intentar de nuevo",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
          ),
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cajaFormulario,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    "Iniciar Sesion",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Ingrese sus credenciales",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    "Correo electronico",
                    correoController,
                    icon: Icons.email,
                  ),
                  _buildTextField(
                    "Contraseña",
                    contrasenaController,
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  _cargando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Iniciar Sesion",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: Center(
                              child: Text(
                                "Funcionalidad de recuperación de contraseña proximamente.",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrarUsuario(),
                        ),
                      );
                    },
                    child: const Text(
                      "¿No tienes una cuenta? Regístrate",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: campos,
          prefixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }
}
