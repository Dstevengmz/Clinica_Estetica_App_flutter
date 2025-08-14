import 'package:flutter/material.dart';
import '../widgets/menulateral.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ProcedimientoModel.dart';
import '../services/ProcedimientoSerivice.dart';
import '../views/iniciodesesion/detallesservicios.dart';
import '../widgets/detallesdeservicios.dart';

class PantallaPrincipal extends StatefulWidget {
  final String? rol;
  const PantallaPrincipal({Key? key, this.rol}) : super(key: key);

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final Color fondoOscuro = const Color(0xFF1B2430);
  final Color segundario = const Color(0xFF334155);
  final Color texto = const Color(0xFFFFFFFF);

  List<Procedimiento> procedimientos = [];
  bool cargando = true;
  String? _rolCargado;
  bool _cargandoRol = false;

  @override
  void initState() {
    super.initState();
    _cargarProcedimientos();
    _cargarRolSiNecesario();
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

  Future<void> cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('rol');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/iniciarsesion');
  }

  Future<void> _cargarRolSiNecesario() async {
    if (widget.rol != null && widget.rol!.isNotEmpty) return;
    setState(() => _cargandoRol = true);
    final prefs = await SharedPreferences.getInstance();
    final rol = prefs.getString('rol');
    if (!mounted) return;
    setState(() {
      _rolCargado = rol;
      _cargandoRol = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: const Text('Servicios Disponibles'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: MenuLateral(
        nombreUsuario: _cargandoRol
            ? 'Cargando...'
            : ((widget.rol ?? _rolCargado) == null ||
                      (widget.rol ?? _rolCargado)!.isEmpty
                  ? 'Invitado'
                  : 'Rol: ${widget.rol ?? _rolCargado}'),
        rol: widget.rol ?? _rolCargado,
        onLogout:
            ((widget.rol ?? _rolCargado) == null ||
                (widget.rol ?? _rolCargado)!.isEmpty)
            ? null
            : () => cerrarSesion(context),
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
                      onTap: () => _abrirDetalle(proc),
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
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("💲 Precio: \$${proc.precio}"),
                                  Text("⏱️ Duración: ${proc.duracion} min"),
                                  Text(
                                    "🩺 Evaluación: ${(proc.requiereEvaluacion == 1) ? 'Sí' : 'No'}",
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
    );
  }

  Future<void> _abrirDetalle(Procedimiento proc) async {
    String? rolActual = widget.rol ?? _rolCargado;
    if ((rolActual == null || rolActual.isEmpty)) {
      final prefs = await SharedPreferences.getInstance();
      rolActual = prefs.getString('rol');
    }
    final invitado = rolActual == null || rolActual.isEmpty;
    if (!mounted) return;
    if (invitado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetallesClinicaSinSesion(
            imageUrl: proc.imagen,
            nombre: proc.nombre,
            duracion: proc.duracion,
            precio: proc.precio,
          ),
        ),
      );
    } else {
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
    }
  }
}
