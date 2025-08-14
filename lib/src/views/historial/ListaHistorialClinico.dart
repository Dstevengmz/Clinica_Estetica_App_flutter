import 'package:flutter/material.dart';
import '../../services/HistorialClinicoService.dart';
import '../../models/HistorialClinicoModel.dart';
import 'DetalleHistorialClinico.dart';

class ListaHistorialClinico extends StatefulWidget {
  const ListaHistorialClinico({Key? key}) : super(key: key);

  @override
  State<ListaHistorialClinico> createState() => _ListaHistorialClinicoState();
}

class _ListaHistorialClinicoState extends State<ListaHistorialClinico> {
  late Future<List<HistorialClinico>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistorialClinicoService.listarHistoriales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historiales Clínicos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<HistorialClinico>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _future = HistorialClinicoService.listarHistoriales();
                      }),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return const Center(child: Text('No hay historiales clínicos'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Usuario')),
                DataColumn(label: Text('Correo')),
                DataColumn(label: Text('Rol')),
                DataColumn(label: Text('Genero')),
                DataColumn(label: Text('Opciones')),
              ],
              rows: lista.map((h) {
                return DataRow(
                  cells: [
                    DataCell(Text('${h.id}')),
                    DataCell(
                      Text(
                        (h.usuario?.nombreCompleto.isNotEmpty == true)
                            ? h.usuario!.nombreCompleto
                            : (h.usuario?.nombre?.isNotEmpty == true)
                            ? h.usuario!.nombre!
                            : '#${h.idUsuario}',
                      ),
                    ),
                    DataCell(
                      Text(
                        (h.usuario?.correo != null &&
                                h.usuario!.correo!.isNotEmpty)
                            ? h.usuario!.correo!
                            : '—',
                      ),
                    ),
                    DataCell(
                      Text(
                        (h.usuario?.rol != null && h.usuario!.rol!.isNotEmpty)
                            ? h.usuario!.rol!
                            : '—',
                      ),
                    ),
                    DataCell(
                      Text(
                        (h.usuario?.genero != null &&
                                h.usuario!.genero!.isNotEmpty)
                            ? h.usuario!.genero!
                            : '—',
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver detalle',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleHistorialClinico(historial: h),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
