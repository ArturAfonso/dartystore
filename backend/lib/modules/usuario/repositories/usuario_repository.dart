


import 'package:backend/modules/usuario/dtos/usuario_dto.dart';
import 'package:backend/modules/usuario/models/usuario_interno.dart';
import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Repository()
class UsuarioRepository {
final Connection _db;
UsuarioRepository(this._db);
Future<List<UsuarioDto>> findAll() async {
final r = await _db.execute(
"SELECT id, nome, email, ativo FROM usuarios ORDER BY id");
return r.map((row) => UsuarioDto(
id: row[0] as int, nome: row[1] as String,
email: row[2] as String, ativo: row[3] as bool)).toList();
}
Future<UsuarioDto?> findById(int id) async {
final r = await _db.execute(
Sql.named("SELECT id,nome,email,ativo FROM usuarios WHERE id=@id"),
parameters: {"id": id});
if (r.isEmpty) return null;
final row = r.first;
return UsuarioDto(id: row[0] as int, nome: row[1] as String,
email: row[2] as String, ativo: row[3] as bool);
}


Future<UsuarioDto> insert(CriarUsuarioDto dto, String senhaHash) async {
  final r = await _db.execute(
    Sql.named(
      'INSERT INTO usuarios (nome, email, senha_hash, ativo) '
      'VALUES (@nome, @email, @hash, true) '
      'RETURNING id, nome, email, ativo'
    ),
    parameters: {'nome': dto.nome, 'email': dto.email, 'hash': senhaHash},
  );
  final row = r.first;
  return UsuarioDto(
    id: row[0] as int,
    nome: row[1] as String,
    email: row[2] as String,
    ativo: row[3] as bool,
  );
}


Future<UsuarioDto> setAtivo(int id, bool ativo) async {
  final r = await _db.execute(
    Sql.named(
      'UPDATE usuarios SET ativo = @ativo '
      'WHERE id = @id '
      'RETURNING id, nome, email, ativo'
    ),
    parameters: {'id': id, 'ativo': ativo},
  );
  final row = r.first;
  return UsuarioDto(
    id: row[0] as int,
    nome: row[1] as String,
    email: row[2] as String,
    ativo: row[3] as bool,
  );
}


Future<void> delete(int id) async {
await _db.execute(
Sql.named("DELETE FROM usuarios WHERE id=@id"),
parameters: {"id": id});
}

// Busca por email — retorna a classe interna com senhaHash
Future<UsuarioInterno?> findByEmail(String email) async {
  final r = await _db.execute(
    Sql.named(
      'SELECT id, nome, email, senha_hash, ativo '
      'FROM usuarios WHERE email = @email'
    ),
    parameters: {'email': email},
  );
  if (r.isEmpty) return null;
  final row = r.first;
  return UsuarioInterno(
    id: row[0] as int,
    nome: row[1] as String,
    email: row[2] as String,
    senhaHash: row[3] as String,
    ativo: row[4] as bool,
  );
}

// Salva o token de reset com validade de 1 hora
Future<void> salvarResetToken(int id, String token) async {
  await _db.execute(
    Sql.named(
      'UPDATE usuarios '
      'SET reset_token = @token, '
      '    reset_token_expiry = NOW() + INTERVAL \'1 hour\' '
      'WHERE id = @id'
    ),
    parameters: {'id': id, 'token': token},
  );
}

// Busca usuário pelo token de reset — só se ainda estiver válido
Future<UsuarioInterno?> findByResetToken(String token) async {
  final r = await _db.execute(
    Sql.named(
      'SELECT id, nome, email, senha_hash, ativo '
      'FROM usuarios '
      'WHERE reset_token = @token '
      '  AND reset_token_expiry > NOW()'  // token expirado é ignorado
    ),
    parameters: {'token': token},
  );
  if (r.isEmpty) return null;
  final row = r.first;
  return UsuarioInterno(
    id: row[0] as int,
    nome: row[1] as String,
    email: row[2] as String,
    senhaHash: row[3] as String,
    ativo: row[4] as bool,
  );
}

// Atualiza a senha com o novo hash
Future<void> atualizarSenha(int id, String senhaHash) async {
  await _db.execute(
    Sql.named(
      'UPDATE usuarios SET senha_hash = @hash WHERE id = @id'
    ),
    parameters: {'id': id, 'hash': senhaHash},
  );
}

// Limpa o token após uso — invalida o link de reset
Future<void> limparResetToken(int id) async {
  await _db.execute(
    Sql.named(
      'UPDATE usuarios '
      'SET reset_token = NULL, reset_token_expiry = NULL '
      'WHERE id = @id'
    ),
    parameters: {'id': id},
  );
}

Future<UsuarioDto> update(int id, AtualizarUsuarioDto dto) async {
  final r = await _db.execute(
    Sql.named(
      'UPDATE usuarios SET nome = @nome, email = @email '
      'WHERE id = @id '
      'RETURNING id, nome, email, ativo'
    ),
    parameters: {'id': id, 'nome': dto.nome, 'email': dto.email},
  );
  final row = r.first;
  return UsuarioDto(
    id: row[0] as int,
    nome: row[1] as String,
    email: row[2] as String,
    ativo: row[3] as bool,
  );
}
}