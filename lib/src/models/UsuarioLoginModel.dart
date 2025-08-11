class Usuario {
  String correo;
  String contrasena;

  Usuario({required this.correo, required this.contrasena});

  Map<String, dynamic> toJson() {
    return {'correo': correo, 'contrasena': contrasena};
  }
}
