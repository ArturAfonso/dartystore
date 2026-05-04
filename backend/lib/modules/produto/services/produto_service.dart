



import 'package:backend/modules/produto/dtos/produto_dto.dart';
import 'package:backend/modules/produto/repositories/produto_repository.dart';
import 'package:vaden/vaden.dart';

@Service()
class ProdutoService {
final ProdutoRepository _repo;
ProdutoService(this._repo);
Future<List<ProdutoDto>> listarTodos() => _repo.findAll();
Future<ProdutoDto> buscarPorId(int id) async {
final p = await _repo.findById(id);
if (p == null) throw ResponseException.notFound("Produto $id não encontrado");
return p;
}
Future<ProdutoDto> criar(CriarProdutoDto dto) => _repo.insert(dto);
Future<ProdutoDto> editar(int id, AtualizarProdutoDto dto) async {
await buscarPorId(id);
return _repo.update(id, dto);
}
Future<void> excluir(int id) async {
await buscarPorId(id);
await _repo.delete(id);
}
}