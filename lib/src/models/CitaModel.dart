class Cita {
  final int? id;
  final DateTime? fecha;
  final String? tipo;
  final DoctorMini? doctor;
  final UsuarioMini? usuario;

  Cita({this.id, this.fecha, this.tipo, this.doctor, this.usuario});

  factory Cita.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return Cita(
      id: parseInt(json['id']),
      fecha: parseDate(json['fecha']),
      tipo: json['tipo']?.toString(),
      doctor: json['doctor'] is Map<String, dynamic>
          ? DoctorMini.fromJson(json['doctor'])
          : null,
      usuario: json['usuario'] is Map<String, dynamic>
          ? UsuarioMini.fromJson(json['usuario'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (fecha != null) 'fecha': fecha!.toIso8601String(),
    if (tipo != null) 'tipo': tipo,
    if (doctor != null) 'doctor': doctor!.toJson(),
    if (usuario != null) 'usuario': usuario!.toJson(),
  };
}

class DoctorMini {
  final int? id;
  final String? nombre;
  final String? especialidad;

  DoctorMini({this.id, this.nombre, this.especialidad});

  factory DoctorMini.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return DoctorMini(
      id: parseInt(json['id']),
      nombre: json['nombre']?.toString(),
      especialidad: (json['especialidad'] ?? json['especialidad_nombre'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (nombre != null) 'nombre': nombre,
    if (especialidad != null) 'especialidad': especialidad,
  };
}

class UsuarioMini {
  final int? id;
  final String? nombre;

  UsuarioMini({this.id, this.nombre});

  factory UsuarioMini.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return UsuarioMini(
      id: parseInt(json['id']),
      nombre: (json['nombre'] ?? json['full_name'] ?? json['username'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (nombre != null) 'nombre': nombre,
  };
}
