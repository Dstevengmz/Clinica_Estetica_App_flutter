class LoginResponse {
  final String token;
  final String nombre;
  final String correo;

  LoginResponse({
    required this.token,
    required this.nombre,
    required this.correo,
  });

  // Para construir el objeto desde un JSON (respuesta del backend)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
    );
  }

  // Para convertir el objeto a JSON (por ejemplo, para guardarlo)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'nombre': nombre,
      'correo': correo,
    };
  }

  // Para modificar solo algunos campos
  LoginResponse copyWith({
    String? token,
    String? nombre,
    String? correo,
  }) {
    return LoginResponse(
      token: token ?? this.token,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
    );
  }
}
