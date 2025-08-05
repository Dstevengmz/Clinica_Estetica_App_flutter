import 'LoginScreen.dart';
import 'package:flutter/material.dart';
import 'menuDrawerPerfil.dart';
import 'RegistrarUsuario.dart';
import 'DetallesClinica.dart';
import 'LoginSinIniciarSesion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuPrincipalSesion extends StatefulWidget {
  @override
  _MenuPrincipalSesionState createState() => _MenuPrincipalSesionState();
}

class _MenuPrincipalSesionState extends State<MenuPrincipalSesion> {
 final Color fondo = Color(0xFF0F172A);        // Fondo general oscuro (casi negro azulado)
final Color primario = Color(0xFF1E293B);     // Contenedor principal (tarjetas, appbar)
final Color segundario = Color(0xFF334155);   // Campos de texto / entradas
final Color detalle = Color(0xFF22C55E);      // Botón principal (verde brillante)
final Color texto = Color(0xFFFFFFFF);
final Color linkAzul = Color(0xFF3B82F6);     // Enlaces como “¿Olvidaste tu contraseña?”
final Color grisClaro = Color(0xFF94A3B8);    // Texto secundario (como el placeholder)
        // Texto blanco



  List<Map<String, dynamic>> procedimientos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProcedimientos();
  }

  Future<void> cargarProcedimientos() async {
    final url = Uri.parse("https://clinicaestetica-464e4aa14f0d.herokuapp.com/apiprocedimientos/listarprocedimiento");

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);
        setState(() {
          procedimientos = List<Map<String, dynamic>>.from(datos.map((item) => {
            'imagen': item['imagen'],
            'nombre': item['nombre'],
            'duracion': int.tryParse(item['duracion'].toString()) ?? 0,
            'precio': int.tryParse(item['precio'].toString()) ?? 0,
            'requiere_evaluacion': int.tryParse(item['requiere_evaluacion'].toString()) ?? 0,
          }));
          cargando = false;
        });
      } else {
        throw Exception("Error al cargar los procedimientos");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuDrawerPerfil(),
      appBar: AppBar(
        title: Text('Clinica Estetica - rejuvenezk'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: primario),
                hintStyle: TextStyle(color: texto.withOpacity(0.5)),
                filled: true,
                fillColor: segundario,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: cargando
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: procedimientos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final proc = procedimientos[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesClinica(
                                    imageUrl: proc['imagen'] ?? '',
                                    nombre: proc['nombre'] ?? 'Sin nombre',
                                    duracion: proc['duracion'] ?? 0,
                                    precio: proc['precio'] ?? 0,
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
                                    proc['imagen'] ?? '',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          proc['nombre'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("💲 Precio: \$${proc['precio'] ?? 0}"),
                                        Text("⏱️ Duración: ${proc['duracion'] ?? 0} min"),
                                        Text("🩺 Evaluación: ${(proc['requiere_evaluacion'] ?? 0) == 1 ? 'Sí' : 'No'}"),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPrincipalSesion()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuDrawerPerfil()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarUsuario()),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: primario),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: primario),
            label: 'Alquiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: primario),
            label: 'Usuario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration, color: primario),
            label: 'Registrar',
          ),
        ],
      ),
    );
  }
}
