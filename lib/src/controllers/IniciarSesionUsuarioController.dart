import '../models/Usuariomodel.dart';
import '../services/IniciarSesionUsuarioService.dart';

class UsuarioController {
  Future<bool> registrar(Usuario usuario, String contrasena) async {
    return await loginUsuario(usuario.correo, contrasena) != null;
  }
}
