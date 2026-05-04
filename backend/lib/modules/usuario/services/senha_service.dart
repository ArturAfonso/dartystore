
import 'package:bcrypt/bcrypt.dart';
import 'package:vaden/vaden.dart';

@Service()
class SenhaService {

  // Gera o hash da senha — chame no cadastro e no reset
  String hash(String senha) {
    return BCrypt.hashpw(senha, BCrypt.gensalt());
  }

  // Verifica se a senha bate com o hash armazenado — chame no login
  bool verificar(String senha, String hash) {
    return BCrypt.checkpw(senha, hash);
  }
}