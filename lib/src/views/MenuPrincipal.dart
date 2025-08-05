import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DetallesClinicaSinSesion.dart';
import 'menuDrawerPerfil.dart';
import 'LoginSinIniciarSesion.dart';

class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
final Color fondo = Color(0xFF0F172A);        // Fondo general oscuro (casi negro azulado)
final Color primario = Color(0xFF1E293B);     // Contenedor principal (tarjetas, appbar)
final Color segundario = Color(0xFF334155);   // Campos de texto / entradas
final Color detalle = Color(0xFF22C55E);      // Botón principal (verde brillante)
final Color texto = Color(0xFFFFFFFF);     
final Color linkAzul = Color(0xFF3B82F6);     // Enlaces como “¿Olvidaste tu contraseña?”
final Color grisClaro = Color(0xFF94A3B8);    // Texto secundario (como el placeholder)
   // Texto blanco


  List<Map<String, dynamic>> listaDeProcedimientos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtenerProcedimientos();
  }

  Future<void> obtenerProcedimientos() async {
    final url = Uri.parse('https://clinicaestetica-464e4aa14f0d.herokuapp.com/apiprocedimientos/listarprocedimiento');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(respuesta.body);
        setState(() {
          listaDeProcedimientos = List<Map<String, dynamic>>.from(datos.map((item) => {
            'imagen': item['imagen'],
            'nombre': item['nombre'],
            'duracion': int.tryParse(item['duracion'].toString()) ?? 0,
            'precio': int.tryParse(item['precio'].toString()) ?? 0,
            'requiere_evaluacion': int.tryParse(item['requiere_evaluacion'].toString()) ?? 0,
          }));
          cargando = false;
        });
      } else {
        throw Exception('Error al obtener datos: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error: \$e');
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuDrawerSinSesion(),
      appBar: AppBar(
        title: Text('Clinica Estetica - rejuvenezk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: primario),
                hintText: 'Buscar procedimiento...',
                hintStyle: TextStyle(color: texto.withOpacity(0.5)),
                filled: true,
                fillColor: segundario,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            cargando
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: listaDeProcedimientos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final procedimiento = listaDeProcedimientos[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesClinicaSinSesion(
                                    imageUrl: procedimiento['imagen'] ?? '',
                                    nombre: procedimiento['nombre'] ?? 'Sin nombre',
                                    duracion: procedimiento['duracion'] ?? 0,
                                    precio: procedimiento['precio'] ?? 0,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    procedimiento['imagen'] ?? '',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                        child: Icon(Icons.image_not_supported),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          procedimiento['nombre'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("💲 Precio: \$\${procedimiento['precio'] ?? 0}"),
                                        Text("⏱️ Duración: \${procedimiento['duracion'] ?? 0} min"),
                                        Text("🩺 Evaluación: \${(procedimiento['requiere_evaluacion'] ?? 0) == 1 ? 'Sí' : 'No'}"),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blueAccent,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
