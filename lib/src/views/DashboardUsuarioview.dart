import 'package:flutter/material.dart';
import '../services/ProcedimientoSerivice.dart';
import '../models/ProcedimientoModel.dart';
import 'DetallesClinica.dart';
import 'RegistrarUsuarioView.dart';
import 'PantallaLoginview.dart';
import 'menuDrawerPerfil.dart'; // Drawer del doctor que quieres reutilizar

class PantallaUsuario extends StatefulWidget {
  const PantallaUsuario({super.key});

  @override
  State<PantallaUsuario> createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  List<Procedimiento> procedimientos = [];
  bool cargando = true;

  final Color fondo = const Color(0xFF0F172A);
  final Color primario = const Color(0xFF1E293B);

  int _paginaActual = 1;

  @override
  void initState() {
    super.initState();
    _cargarProcedimientos();
  }

  Future<void> _cargarProcedimientos() async {
    try {
      final lista = await ProcedimientoService.listarProcedimientos();
      setState(() {
        procedimientos = lista;
        cargando = false;
      });
    } catch (e) {
      print('Error al cargar procedimientos: $e');
      setState(() => cargando = false);
    }
  }

  void _onTapBottomNavigation(int index) {
    setState(() {
      _paginaActual = index;
    });

    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PantallaUsuario()),
        );
        break;
      case 1: // Procedimientos (actual pantalla)
        break;
      case 2: // Perfil (mismo drawer del doctor)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MenuDrawerPerfil()),
        );
        break;
      case 3: // Registrar usuario
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegistrarUsuario()),
        );
        break;
      case 4: // Cerrar sesión / login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuDrawerPerfil(),
      appBar: AppBar(
        title: const Text('Bienvenido Usuario'),
        backgroundColor: primario,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: procedimientos.length,
                itemBuilder: (context, index) {
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
                              imageUrl: proc.imagen,
                              nombre: proc.nombre,
                              duracion: proc.duracion,
                              precio: proc.precio,
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
                              proc.imagen,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
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
                                    proc.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("💲 Precio: \$${proc.precio}"),
                                  Text("⏱️ Duración: ${proc.duracion} min"),
                                  Text(
                                    "🩺 Evaluación: ${proc.requiereEvaluacion == 1 ? 'Sí' : 'No'}",
                                  ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: _onTapBottomNavigation,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: primario.withOpacity(0.5),
        backgroundColor: primario,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Procedimientos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
      ),
    );
  }
}
