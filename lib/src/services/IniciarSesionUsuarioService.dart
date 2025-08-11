// Función para iniciar sesión
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>?> loginUsuario(
  String correo,
  String contrasena,
) async {
  final baseUrl = dotenv.env['API_BASE_URL'];
  if (baseUrl == null) return null;

  final url = Uri.parse('$baseUrl/apiusuarios/iniciarsesion');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error en login: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Excepción en login: $e');
    return null;
  }
}
