class Usuario {
  String nombre;
  String correo;
  String contrasena;
  String tipodocumento;
  String numerodocumento;
  String rol;
  String telefono;
  String genero;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.tipodocumento,
    required this.numerodocumento,
    required this.rol,
    required this.telefono,
    required this.genero,
  });

  // Para enviar datos al servidor
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'tipodocumento': tipodocumento,
      'numerodocumento': numerodocumento,
      'rol': rol,
      'telefono': telefono,
      'genero': genero,
    };
  }

  // Para crear un objeto Usuario desde los datos del servidor
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      contrasena: json['contrasena'] ?? '',
      tipodocumento: json['tipodocumento'] ?? '',
      numerodocumento: json['numerodocumento'] ?? '',
      rol: json['rol'] ?? '',
      telefono: json['telefono'] ?? '',
      genero: json['genero'] ?? '',
    );
  }
}
