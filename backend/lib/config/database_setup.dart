import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Component()
class DatabaseSetup implements ApplicationRunner {
final Connection _db;
DatabaseSetup(this._db);
@override
Future<void> run(VadenApplication app) async {
await _db.execute("""
CREATE TABLE IF NOT EXISTS usuarios (
    id                SERIAL PRIMARY KEY,
    nome              VARCHAR(255) NOT NULL,
    email             VARCHAR(255) NOT NULL UNIQUE,
    senha_hash        VARCHAR(255) NOT NULL,
    ativo             BOOLEAN NOT NULL DEFAULT true,
    reset_token       VARCHAR(255),
    reset_token_expiry TIMESTAMP,
    criado_em         TIMESTAMP DEFAULT NOW()
  )
""");
await _db.execute("""
CREATE TABLE IF NOT EXISTS produtos (
id SERIAL PRIMARY KEY,
nome VARCHAR(255) NOT NULL,
preco DOUBLE PRECISION NOT NULL,
ativo BOOLEAN NOT NULL DEFAULT true
)
""");
print("■ Tabelas prontas!");
}
}