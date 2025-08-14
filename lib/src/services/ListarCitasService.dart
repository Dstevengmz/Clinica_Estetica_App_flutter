import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/CitaModel.dart';

class ListarCitasService {
  // Equivalente al hook useMisCitas: obtiene "mis citas" del backend
  static Future<List<Cita>> listarMisCitas() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      throw Exception('API_BASE_URL no definido en .env');
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token no disponible. Usuario no autenticado.');
    }

    final url = Uri.parse('$baseUrl/apicitas/miscitas');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data
            .map((e) => Cita.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => Cita.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw Exception('Formato inesperado de respuesta');
      }
    } else if (response.statusCode == 401) {
      final body = json.decode(response.body);
      final msg = body is Map && body['mensaje'] != null
          ? body['mensaje']
          : 'No autorizado';
      throw Exception('401: $msg');
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
