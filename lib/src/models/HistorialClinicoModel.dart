class HistorialClinico {
  final int? id;
  final int idUsuario;
  // Datos del usuario (opcional, viene anidado como "usuario" en la API)
  final UsuarioHistorial? usuario;
  final String? enfermedades;
  final String? alergias;
  final String? cirugiasPrevias;
  final String? condicionesPiel;
  final bool? embarazoLactancia;
  final String? medicamentos;
  final bool? consumeTabaco;
  final bool? consumeAlcohol;
  final bool? usaAnticonceptivos;
  final String? detallesAnticonceptivos;
  final bool? diabetes;
  final bool? hipertension;
  final bool? historialCancer;
  final bool? problemasCoagulacion;
  final bool? epilepsia;
  final String? otrasCondiciones;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HistorialClinico({
    this.id,
    required this.idUsuario,
    this.usuario,
    this.enfermedades,
    this.alergias,
    this.cirugiasPrevias,
    this.condicionesPiel,
    this.embarazoLactancia,
    this.medicamentos,
    this.consumeTabaco,
    this.consumeAlcohol,
    this.usaAnticonceptivos,
    this.detallesAnticonceptivos,
    this.diabetes,
    this.hipertension,
    this.historialCancer,
    this.problemasCoagulacion,
    this.epilepsia,
    this.otrasCondiciones,
    this.createdAt,
    this.updatedAt,
  });

  factory HistorialClinico.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    bool? parseBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final s = v.toString().toLowerCase();
      return s == 'true' || s == '1' || s == 't' || s == 'yes';
    }

    return HistorialClinico(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      idUsuario: json['id_usuario'] is int
          ? json['id_usuario']
          : int.tryParse('${json['id_usuario']}') ?? 0,
      usuario: json['usuario'] is Map<String, dynamic>
          ? UsuarioHistorial.fromJson(json['usuario'])
          : null,
      enfermedades: json['enfermedades'],
      alergias: json['alergias'],
      cirugiasPrevias: json['cirugias_previas'],
      condicionesPiel: json['condiciones_piel'],
      embarazoLactancia: parseBool(json['embarazo_lactancia']),
      medicamentos: json['medicamentos'],
      consumeTabaco: parseBool(json['consume_tabaco']),
      consumeAlcohol: parseBool(json['consume_alcohol']),
      usaAnticonceptivos: parseBool(json['usa_anticonceptivos']),
      detallesAnticonceptivos: json['detalles_anticonceptivos'],
      diabetes: parseBool(json['diabetes']),
      hipertension: parseBool(json['hipertension']),
      historialCancer: parseBool(json['historial_cancer']),
      problemasCoagulacion: parseBool(json['problemas_coagulacion']),
      epilepsia: parseBool(json['epilepsia']),
      otrasCondiciones: json['otras_condiciones'],
      createdAt: parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: parseDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'id_usuario': idUsuario,
    if (usuario != null) 'usuario': usuario!.toJson(),
    'enfermedades': enfermedades,
    'alergias': alergias,
    'cirugias_previas': cirugiasPrevias,
    'condiciones_piel': condicionesPiel,
    'embarazo_lactancia': embarazoLactancia,
    'medicamentos': medicamentos,
    'consume_tabaco': consumeTabaco,
    'consume_alcohol': consumeAlcohol,
    'usa_anticonceptivos': usaAnticonceptivos,
    'detalles_anticonceptivos': detallesAnticonceptivos,
    'diabetes': diabetes,
    'hipertension': hipertension,
    'historial_cancer': historialCancer,
    'problemas_coagulacion': problemasCoagulacion,
    'epilepsia': epilepsia,
    'otras_condiciones': otrasCondiciones,
  };
}

class UsuarioHistorial {
  final int? id;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String? rol;
  final String? genero;

  UsuarioHistorial({
    this.id,
    this.nombre,
    this.apellido,
    this.correo,
    this.rol,
    this.genero,
  });

  factory UsuarioHistorial.fromJson(Map<String, dynamic> json) {
    return UsuarioHistorial(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      nombre: json['nombre']?.toString(),
      apellido: json['apellido']?.toString() ?? json['apellidos']?.toString(),
      correo: (json['correo'] ?? json['email'])?.toString(),
      rol: json['rol']?.toString(),
      genero: json['genero']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (nombre != null) 'nombre': nombre,
    if (apellido != null) 'apellido': apellido,
    if (correo != null) 'correo': correo,
    if (rol != null) 'rol': rol,
    if (genero != null) 'genero': genero,
  };

  String get nombreCompleto {
    if ((nombre ?? '').isEmpty && (apellido ?? '').isEmpty) return '';
    return [nombre, apellido].where((e) => e != null && e.isNotEmpty).join(' ');
  }
}
