




import 'dart:convert';

import 'package:backend/modules/auth/dtos/confirmar_reset_dto.dart';
import 'package:backend/modules/auth/dtos/login_dto.dart';
import 'package:backend/modules/auth/dtos/reset_senha_dto.dart';
import 'package:backend/modules/auth/dtos/token_dto.dart';
import 'package:backend/modules/auth/services/auth_service.dart';
import 'package:backend/modules/usuario/dtos/reset_senha_dto.dart';
import 'package:vaden/vaden.dart';


@Api(tag: "auth", description: "Autenticação")
@Controller("/auth")
class AuthController {
final AuthService _auth;
AuthController(this._auth);
@ApiOperation(summary: "Login")
@Post("/login")
Future<TokenDto> login(@Body() LoginDto dto) async {
  return await _auth.login(dto);  // ← async/await resolve a inferência
}

@ApiOperation(summary: 'Solicita reset de senha por e-mail')
@ApiResponse(200, description: 'E-mail enviado se o endereço existir')
@Post('/solicitar-reset')
Future<Response> solicitarReset(@Body() ResetSenhaDto dto) async {
  await _auth.solicitarReset(dto.email);
  return Response.ok('Se o e-mail existir, as instrucoes foram enviadas.');
}

@ApiOperation(summary: 'Confirma o reset com o token recebido por e-mail')
@ApiResponse(200, description: 'Senha redefinida com sucesso')
@ApiResponse(400, description: 'Token invalido ou expirado')
@Post('/confirmar-reset')
Future<Response> confirmarReset(@Body() ConfirmarResetDto dto) async {
  await _auth.confirmarReset(dto.token, dto.novaSenha);
  return Response.ok('Senha redefinida com sucesso.');
}


}