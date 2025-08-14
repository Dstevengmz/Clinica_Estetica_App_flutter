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
      String limpiarBase(String v) {
        while (v.endsWith('/')) {
          v = v.substring(0, v.length - 1);
        }
        return v;
      }

      final baseLimpia = limpiarBase(baseUrl);
      return (datos as List).map((item) {
        final p = Procedimiento.fromJson(item);
        final raw = p.imagen.trim();
        final completa = raw.isEmpty
            ? ''
            : (raw.startsWith('http')
                  ? raw
                  : '$baseLimpia/${raw.startsWith('/') ? raw.substring(1) : raw}');
        return Procedimiento(
          imagen: completa,
          nombre: p.nombre,
          duracion: p.duracion,
          precio: p.precio,
          requiereEvaluacion: p.requiereEvaluacion,
        );
      }).toList();
    } else {
      throw Exception('Error al cargar procedimientos');
    }
  }
}
