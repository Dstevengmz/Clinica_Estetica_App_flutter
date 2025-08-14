import 'package:flutter/material.dart';

class DetallesClinicaSinSesion extends StatelessWidget {
  final String imageUrl;
  final String nombre;
  final int duracion;
  final int precio;

  DetallesClinicaSinSesion({
    required this.imageUrl,
    required this.nombre,
    required this.duracion,
    required this.precio,
  });

  final Color fondo = const Color(0xFF0D1B2A);
  final Color encabezado = const Color(0xFF1B263B);
  final Color campos = const Color(0xFF415A77);
  final Color boton = const Color(0xFF2ECC71);
  final Color texto = const Color(0xFFE0E1DD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text("Detalle del Servicio"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildInfoItem("💲 Precio del servicio:", "\$$precio"),
            _buildInfoItem("⏱️ Duración:", "$duracion minutos"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/iniciarsesion');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: boton,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Inicia sesión para realizar una cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: texto,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 18, color: texto),
            ),
          ),
        ],
      ),
    );
  }
}
