import 'package:flutter/material.dart';
import '../../widgets/menulateral.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../services/IniciarSesionUsuarioService.dart';
import '../pantallaprincipal.dart';
import '../usuario/panelusuario.dart';
import '../doctor/paneldoctor.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<IniciarSesion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool _cargando = false;

  final Color fondoOscuro = const Color(0xFF1B2430);
  final Color cajaFormulario = const Color(0xFF222E3C);
  final Color campos = const Color(0xFF2E3A4B);
  final Color textoClaro = Colors.white70;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);

      final token = await loginUsuario(
        correoController.text.trim(),
        contrasenaController.text.trim(),
      );

      setState(() => _cargando = false);

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Extraer rol de la respuesta
        final String rol = token['usuario']?['rol']?.toString() ?? '';

        // Intentar detectar nombre del campo token en la respuesta
        String? rawToken;
        if (token.containsKey('token')) {
          rawToken = token['token']?.toString();
        } else if (token.containsKey('access_token')) {
          rawToken = token['access_token']?.toString();
        } else if (token.containsKey('jwt')) {
          rawToken = token['jwt']?.toString();
        }

        if (rawToken != null && rawToken.isNotEmpty) {
          await prefs.setString('token', rawToken);
        }
        await prefs.setString('rol', rol);

        if (!mounted) return;

        final destino = () {
          final r = rol.toUpperCase();
          if (r == 'DOCTOR') return const PantallaDoctor();
          if (r == 'USUARIO' || r == 'CLIENTE') return const PantallaUsuario();
          return PantallaPrincipal(rol: rol);
        }();

        Alert(
          context: context,
          title: 'Bienvenido',
          desc: 'Sesión iniciada correctamente.',
          image: Image.asset('assets/img/success.png', height: 90),
          buttons: [
            DialogButton(
              child: const Text(
                'CONTINUAR',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => destino),
                );
              },
              gradient: const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
              ),
            ),
          ],
        ).show();
      } else {
        if (!mounted) return;
        Alert(
          context: context,
          type: AlertType.error,
          title: "Usuario o contraseña incorrectos",
          desc: "Por favor, verifica tus credenciales e intenta nuevamente.",
          buttons: [],
        ).show();
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      drawer: MenuLateral(
        nombreUsuario: 'Invitado',
        onLogout: () {
          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                    "Iniciar Sesión",
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
                    "Correo electrónico",
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
                            "Iniciar Sesión",
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
                                "Funcionalidad de recuperación de contraseña próximamente.",
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
                          builder: (_) => const Scaffold(
                            body: Center(
                              child: Text(
                                "Pantalla de registro próximamente.",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
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
