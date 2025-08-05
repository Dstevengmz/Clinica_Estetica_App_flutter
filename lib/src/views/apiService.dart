import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Usuario.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/Usuario.dart';



// Función para registrar un usuario
Future<bool> registrarUsuario(Usuario usuario) async {
  final url = Uri.parse('https://clinicaestetica-464e4aa14f0d.herokuapp.com/apiusuarios/crearusuarios');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    print('📤 Cuerpo enviado: ${usuario.toJson()}');
    print('📥 Código de respuesta: ${response.statusCode}');
    print('📥 Respuesta body:\n${response.body}');

    // ✅ Aceptar tanto 200 como 201 como válidos
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Usuario registrado exitosamente.');
      return true;
    } else {
      print('❌ Error al registrar: ${response.statusCode}');
      print('❌ Detalles: ${response.body}');
      return false;
    }
  } catch (e) {
    print('⚠️ Excepción al registrar: $e');
    return false;
  }
}

// Función para iniciar sesión
Future<String?> loginUsuario(String correo, String contrasena) async {
  final url = Uri.parse('https://clinicaestetica-464e4aa14f0d.herokuapp.com/apiusuarios/iniciarsesion');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Devuelve el token
    } else {
      print('Error en login: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Excepción en login: $e');
    return null;
  }
}
Future<bool> recuperarContrasena(String correo) async {
  final url = Uri.parse('https://clinicaestetica-464e4aa14f0d.herokuapp.com/apiusuarios/recuperarcontrasena'); // Modifica según tu ruta real

  try {
    final response = await http.post(
      url,
      body: {'correo': correo},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error en recuperación: $e');
    return false;
  }
}
Future<Map<String, dynamic>?> loginUsuarioConDatos(String correo, String contrasena) async {
  final url = Uri.parse('https://clinicaestetica-464e4aa14f0d.herokuapp.com/api/login'); // ⚠️ Asegúrate que esta sea la URL correcta

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'correo': correo,
      'contrasena': contrasena,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print("Error login: ${response.body}");
    return null;
  }
}