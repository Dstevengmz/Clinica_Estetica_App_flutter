import 'package:flutter/material.dart';

class TarjetaProducto extends StatelessWidget {
  final Map<String, dynamic> producto;

  const TarjetaProducto({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final String nombre = producto["nombre"];
    final String imagen = producto["imagen"];
    final int precio = producto["precio"];
    final int duracion = producto["duracion"];
    final bool requiereEvaluacion = producto["requiere_evaluacion"] == 1;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(imagen, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text("💲 Precio: \$${precio}"),
                Text("⏱️ Duración: ${duracion} min"),
                Text("🩺 Evaluación: ${requiereEvaluacion ? 'Sí' : 'No'}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
