import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';
import 'package:vaden/vaden.dart';
import '../../usuario/repositories/usuario_repository.dart';
import '../../usuario/services/senha_service.dart';
import '../dtos/login_dto.dart';
import '../dtos/token_dto.dart';
import 'email_service.dart';  // veremos abaixo

@Service()
class AuthService {
  final UsuarioRepository _repo;
  final SenhaService _senhaService;
  final EmailService _emailService;

  AuthService(this._repo, this._senhaService, this._emailService);

  String get _secret =>
    Platform.environment['JWT_SECRET'] ?? 'fallback_local';

  Future<TokenDto> login(LoginDto dto) async {
    final user = await _repo.findByEmail(dto.email);
    if (user == null)
      throw ResponseException.unauthorized('Credenciais invalidas');
    if (!user.ativo)
      throw ResponseException.unauthorized('Usuario inativo');
    if (!_senhaService.verificar(dto.senha, user.senhaHash))
      throw ResponseException.unauthorized('Credenciais invalidas');

    final jwt = JWT({'id': user.id, 'email': user.email});
    final token = jwt.sign(SecretKey(_secret), expiresIn: Duration(hours: 8));
    return TokenDto(token, 'Bearer');
  }

  Future<void> solicitarReset(String email) async {
    final user = await _repo.findByEmail(email);
    if (user == null) return;  // silencioso — não revela se e-mail existe

    final token = Uuid().v4();           // gera token único
    await _repo.salvarResetToken(user.id, token);
    await _emailService.enviarResetSenha(email, token);
  }

  Future<void> confirmarReset(String token, String novaSenha) async {
    final user = await _repo.findByResetToken(token);
    if (user == null)
      throw ResponseException.badRequest('Token invalido ou expirado');

    final hash = _senhaService.hash(novaSenha);
    await _repo.atualizarSenha(user.id, hash);
    await _repo.limparResetToken(user.id);  // token usado → invalida
  }
}