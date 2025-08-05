import 'package:flutter/material.dart';
import 'src/views/MenuPrincipal.dart';
import 'src/views/splash_screen.dart';
import 'src/views/tratamientos.dart';
import 'src/views/LoginScreen.dart'; // Asegúrate de que existe este archivo
import 'src/views/RegistrarUsuario.dart'; // Asegúrate de que existe este archivo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Estética',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistrarUsuario(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> productos = [
      {
        "nombre": "Limpieza facial profunda",
        "precio": 150,
        "duracion": 60,
        "requiere_evaluacion": 1,
        "imagen":
            "https://stronglify-1.s3.sa-east-1.amazonaws.com/farmadodo/Limpieza-facial-Como-hacer-una-limpieza-facial-en-casa.jpg",
      },
      {
        "nombre": "Masaje reductor",
        "precio": 200,
        "duracion": 50,
        "requiere_evaluacion": 0,
        "imagen":
            "https://cenrefk.com/wp-content/uploads/2023/02/servicio-de-masajes-reductores-en-Riobamba.jpg",
      },
      {
        "nombre": "Microdermoabrasión",
        "precio": 180,
        "duracion": 45,
        "requiere_evaluacion": 1,
        "imagen":
            "https://www.materialestetica.com/blog/wp-content/uploads/2018/07/microdermoabrasion.jpg",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: MenuPrincipal(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          children: productos
              .map((producto) => TarjetaProducto(producto: producto))
              .toList(),
        ),
      ),
    );
  }
}
