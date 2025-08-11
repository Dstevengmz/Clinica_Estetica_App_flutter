import '../models/Usuariomodel.dart';
import '../services/RegistrarUsuarioService.dart';

class UsuarioController {
  Future<bool> registrar(Usuario usuario) async {
    return await registrarUsuario(usuario);
  }
}
