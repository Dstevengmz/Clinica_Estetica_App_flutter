import 'package:flutter/material.dart';
import '../../models/CitaModel.dart';
import '../../services/ListarCitasService.dart';

class MisCitasPage extends StatefulWidget {
  const MisCitasPage({Key? key}) : super(key: key);

  @override
  State<MisCitasPage> createState() => _MisCitasPageState();
}

class _MisCitasPageState extends State<MisCitasPage> {
  late Future<List<Cita>> _future;

  @override
  void initState() {
    super.initState();
    _future = ListarCitasService.listarMisCitas();
  }

  void _refrescar() {
    setState(() {
      _future = ListarCitasService.listarMisCitas();
    });
  }

  String _fmtFecha(DateTime? dt) {
    if (dt == null) return '—';
    final d = dt.toLocal();
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$y-$m-$day $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: _refrescar, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<Cita>>(
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
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refrescar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final citas = snapshot.data ?? [];
          if (citas.isEmpty) {
            return const Center(child: Text('No tienes citas registradas.'));
          }

          return ListView.separated(
            itemCount: citas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final c = citas[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.event, color: Colors.deepPurple),
                ),
                title: Text(c.tipo ?? 'Cita'),
                subtitle: Text(
                  '${_fmtFecha(c.fecha)}  •  Doctor: ${c.doctor?.nombre ?? 'N/A'}',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Detalle de la cita'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${c.id ?? '—'}'),
                          Text('Fecha: ${_fmtFecha(c.fecha)}'),
                          Text('Tipo: ${c.tipo ?? '—'}'),
                          Text('Doctor: ${c.doctor?.nombre ?? 'N/A'}'),
                          Text('Paciente: ${c.usuario?.nombre ?? 'Yo'}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
