import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ProcedimientoModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProcedimientoService {
  static Future<List<Procedimiento>> listarProcedimientos() async {
    final baseUrl = dotenv.env['API_BASE_URL'];

    if (baseUrl == null) {
      print('ERROR: API_BASE_URL no está definido en el archivo .env');
      return [];
    }
    final url = Uri.parse('$baseUrl/apiprocedimientos/listarprocedimiento');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final datos = json.decode(response.body);
      return (datos as List)
          .map((item) => Procedimiento.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al cargar procedimientos');
    }
  }
}
