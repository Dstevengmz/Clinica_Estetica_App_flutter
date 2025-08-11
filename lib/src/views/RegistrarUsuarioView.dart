import 'package:flutter/material.dart';
import '../models/Usuariomodel.dart';
import '../services/RegistrarUsuarioService.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrarUsuario extends StatefulWidget {
  const RegistrarUsuario({super.key});

  @override
  State<RegistrarUsuario> createState() => _RegistrarUsuarioState();
}

class _RegistrarUsuarioState extends State<RegistrarUsuario> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _numDocController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  String _tipoDoc = 'Cédula de ciudadanía';
  String _rol = 'Usuario';
  String _genero = 'Masculino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2430),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF222E3C),
              borderRadius: BorderRadius.circular(16),
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Registro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Complete los campos",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Nombre", _nombreController),
                  _buildTextField(
                    "Correo electrónico",
                    _correoController,
                    tipo: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    "Contraseña",
                    _contrasenaController,
                    isPassword: true,
                  ),
                  _buildDropdown(
                    "Tipo de documento",
                    _tipoDoc,
                    [
                      "Cédula de ciudadanía",
                      "Pasaporte",
                      "Documento de identidad extranjero",
                      "Permiso especial de permanencia",
                    ],
                    (value) => setState(() => _tipoDoc = value!),
                  ),
                  _buildTextField(
                    "Número de documento",
                    _numDocController,
                    tipo: TextInputType.number,
                  ),
                  _buildDropdown("Rol", _rol, [
                    "Doctor",
                    "Usuario",
                    "Asistente",
                  ], (value) => setState(() => _rol = value!)),
                  _buildTextField(
                    "Teléfono",
                    _telefonoController,
                    tipo: TextInputType.phone,
                  ),
                  _buildDropdown("Género", _genero, [
                    "Masculino",
                    "Femenino",
                    "Otro",
                  ], (value) => setState(() => _genero = value!)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _confirmarRegistro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Crear cuenta",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      "¿Ya tengo una cuenta?",
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
    TextInputType tipo = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2E3A4B),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String valorActual,
    List<String> opciones,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: valorActual,
          items: opciones
              .map(
                (opcion) =>
                    DropdownMenuItem(value: opcion, child: Text(opcion)),
              )
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF2E3A4B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          dropdownColor: const Color(0xFF2E3A4B),
        ),
      ),
    );
  }

  void _registrarUsuarioConfirmado() async {
    Usuario nuevoUsuario = Usuario(
      nombre: _nombreController.text,
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
      tipodocumento: _tipoDoc,
      numerodocumento: _numDocController.text,
      rol: _rol,
      telefono: _telefonoController.text,
      genero: _genero,
    );

    bool registrado = await registrarUsuario(nuevoUsuario);

    if (registrado) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "¡Registro Exitoso!",
        desc: "Tu cuenta ha sido creada correctamente.",
        buttons: [
          DialogButton(
            child: const Text(
              "Ir al login",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            gradient: const LinearGradient(
              colors: [Color(0xFF00B386), Color(0xFF27CBAD)],
            ),
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Hubo un problema al registrar el usuario.",
        buttons: [
          DialogButton(
            child: const Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
          ),
        ],
      ).show();
    }
  }

  void _confirmarRegistro() {
    if (_formKey.currentState!.validate()) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "¿Estás seguro?",
        desc: "¿Deseas registrar esta cuenta?",
        buttons: [
          DialogButton(
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey,
          ),
          DialogButton(
            child: const Text(
              "Sí, registrar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              _registrarUsuarioConfirmado();
            },
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(0, 179, 134, 1.0),
                Color.fromRGBO(39, 203, 173, 1.0),
              ],
            ),
          ),
        ],
      ).show();
    }
  }
}
