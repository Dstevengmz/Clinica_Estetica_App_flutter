import '../models/ProcedimientoModel.dart';
import '../services/ProcedimientoSerivice.dart';

class ProcedimientoController {
  Future<List<Procedimiento>> obtenerProcedimientos() async {
    return await ProcedimientoService.listarProcedimientos();
  }
}
