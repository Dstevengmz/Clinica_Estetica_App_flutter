import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Usuariomodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> registrarUsuario(Usuario usuario) async {
  final baseUrl = dotenv.env['API_BASE_URL'];

  if (baseUrl == null) {
    print('ERROR: API_BASE_URL no está definido en el archivo .env');
    return false;
  }

  final url = Uri.parse('$baseUrl/apiusuarios/crearusuarios');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    print(' Cuerpo enviado: ${usuario.toJson()}');
    print(' Código de respuesta: ${response.statusCode}');
    print(' Respuesta body:\n${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(' Usuario registrado exitosamente.');
      return true;
    } else {
      print(' Error al registrar: ${response.statusCode}');
      print(' Detalles: ${response.body}');
      return false;
    }
  } catch (e) {
    print(' Excepción al registrar: $e');
    return false;
  }
}
