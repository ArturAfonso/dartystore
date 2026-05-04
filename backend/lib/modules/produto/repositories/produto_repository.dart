

import 'package:backend/modules/produto/dtos/produto_dto.dart';
import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Repository()
class ProdutoRepository {
final Connection _db;
ProdutoRepository(this._db);
Future<List<ProdutoDto>> findAll() async {
final r = await _db.execute("SELECT id,nome,preco,ativo FROM produtos ORDER BY id");
return r.map((row) => ProdutoDto(id: row[0] as int,
nome: row[1] as String, preco: row[2] as double,
ativo: row[3] as bool)).toList();
}
Future<ProdutoDto?> findById(int id) async {
final r = await _db.execute(
Sql.named("SELECT id,nome,preco,ativo FROM produtos WHERE id=@id"),
parameters: {"id": id});
if (r.isEmpty) return null;
final row = r.first;
return ProdutoDto(id: row[0] as int, nome: row[1] as String,
preco: row[2] as double, ativo: row[3] as bool);
}
Future<ProdutoDto> insert(CriarProdutoDto dto) async {
final r = await _db.execute(
Sql.named("INSERT INTO produtos (nome,preco) VALUES (@n,@p) RETURNING id,nome,preco,ativo"),
parameters: {"n": dto.nome, "p": dto.preco});
final row = r.first;
return ProdutoDto(id: row[0] as int, nome: row[1] as String,
preco: row[2] as double, ativo: row[3] as bool);
}
Future<ProdutoDto> update(int id, AtualizarProdutoDto dto) async {
final r = await _db.execute(
Sql.named("UPDATE produtos SET nome=@n,preco=@p WHERE id=@id RETURNING id,nome,preco,ativo"),
parameters: {"id": id, "n": dto.nome, "p": dto.preco});
final row = r.first;
return ProdutoDto(id: row[0] as int, nome: row[1] as String,
preco: row[2] as double, ativo: row[3] as bool);
}
Future<void> delete(int id) async {
await _db.execute(Sql.named("DELETE FROM produtos WHERE id=@id"),
parameters: {"id": id});
}
}