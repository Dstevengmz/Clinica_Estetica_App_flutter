class Usuario {
  String nombre;
  String correo;
  String contrasena;

  Usuario({required this.nombre, required this.correo, required this.contrasena});

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}
