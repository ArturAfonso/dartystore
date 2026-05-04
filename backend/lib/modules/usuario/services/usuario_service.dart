import 'package:vaden/vaden.dart';
import '../repositories/usuario_repository.dart';
import '../dtos/usuario_dto.dart';
import '../dtos/criar_usuario_dto.dart';
import '../dtos/atualizar_usuario_dto.dart';
import 'senha_service.dart';

@Service()
class UsuarioService {
  final UsuarioRepository _repository;
  final SenhaService _senhaService;

  UsuarioService(this._repository, this._senhaService);

  Future<List<UsuarioDto>> listarTodos() => _repository.findAll();

  Future<UsuarioDto> buscarPorId(int id) async {
    final u = await _repository.findById(id);
    if (u == null)
      throw ResponseException.notFound('Usuario $id nao encontrado');
    return u;
  }

  Future<UsuarioDto> criar(CriarUsuarioDto dto) async {
    final hash = _senhaService.hash(dto.senha);  // ← hash antes de salvar
    return _repository.insert(dto, hash);        // ← passa o hash separado
  }

  Future<UsuarioDto> editar(int id, AtualizarUsuarioDto dto) async {
    await buscarPorId(id);
    return _repository.update(id, dto);
  }

  Future<void> excluir(int id) async {
    await buscarPorId(id);
    await _repository.delete(id);
  }

  Future<UsuarioDto> ativar(int id) async {
    await buscarPorId(id);
    return _repository.setAtivo(id, true);
  }

  Future<UsuarioDto> desativar(int id) async {
    await buscarPorId(id);
    return _repository.setAtivo(id, false);
  }
}