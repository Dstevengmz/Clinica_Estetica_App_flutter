import 'package:flutter/material.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  bool _cargando = false;

  // Paleta de colores basada en la imagen
  final Color fondo = const Color(0xFF0F172A); // fondo azul oscuro
  final Color contenedor = const Color(0xFF1E293B); // contenedor gris azulado
  final Color campoTexto = const Color(0xFF334155); // campos de texto gris oscuro
  final Color textoPrimario = Colors.white;
  final Color textoSecundario = const Color(0xFF94A3B8); // gris claro
  final Color botonVerde = const Color(0xFF22C55E); // verde
  final Color linkAzul = const Color(0xFF3B82F6); // azul para enlaces

  void _simularEnvio() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Se ha enviado un correo a ${correoController.text.trim()}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

      Navigator.pop(context); // volver al login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: contenedor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 60, color: textoPrimario),
                  const SizedBox(height: 16),
                  Text(
                    'Recuperar Contraseña',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textoPrimario,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingrese su correo para restablecer la contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: correoController,
                    style: TextStyle(color: textoPrimario),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: campoTexto,
                      hintText: "Correo electrónico",
                      hintStyle: TextStyle(color: textoSecundario),
                      prefixIcon: Icon(Icons.email, color: textoSecundario),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese su correo';
                      }
                      if (!value.contains('@')) {
                        return 'Correo no válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: _cargando
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _simularEnvio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: botonVerde,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Enviar solicitud",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Volver al inicio de sesión",
                      style: TextStyle(
                        color: linkAzul,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
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
}
