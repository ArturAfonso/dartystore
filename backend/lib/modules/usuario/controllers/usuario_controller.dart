import 'package:shelf/shelf.dart';
import 'package:vaden/vaden.dart';
import 'package:backend/modules/auth/guards/jwt_guard.dart';
import 'package:backend/modules/usuario/dtos/usuario_dto.dart';
import 'package:backend/modules/usuario/dtos/criar_usuario_dto.dart';
import 'package:backend/modules/usuario/dtos/atualizar_usuario_dto.dart';
import 'package:backend/modules/usuario/dtos/reset_senha_dto.dart';
import 'package:backend/modules/usuario/services/usuario_service.dart';

@Api(tag: 'usuarios', description: 'Gestao de usuarios')
@Controller('/usuarios')
class UsuarioController {
  final UsuarioService _service;
  UsuarioController(this._service);

  // ── PÚBLICOS ────────────────────────────────────────────────
  @ApiOperation(summary: 'Criar usuario')
  @Post('/')
  Future<UsuarioDto> criar(@Body() CriarUsuarioDto dto) async
    => await _service.criar(dto);

  @ApiOperation(summary: 'Solicitar reset de senha')
  @Post('/reset-senha')
  Future<Response> resetSenha(@Body() ResetSenhaDto dto) async {
    await _service.solicitarResetSenha(dto);
    return Response.ok('Instrucoes enviadas se o e-mail existir.');
  }

  // ── PROTEGIDOS ──────────────────────────────────────────────
  @ApiOperation(summary: 'Listar todos')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Get('/')
  Future<List<UsuarioDto>> listar() async
    => await _service.listarTodos();

  @ApiOperation(summary: 'Buscar por ID')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Get('/<id>')
  Future<UsuarioDto> buscar(@Param('id') int id) async
    => await _service.buscarPorId(id);

  @ApiOperation(summary: 'Editar usuario')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Put('/<id>')
  Future<UsuarioDto> editar(
    @Param('id') int id, @Body() AtualizarUsuarioDto dto) async
    => await _service.editar(id, dto);

  @ApiOperation(summary: 'Excluir usuario')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Delete('/<id>')
  Future<Response> excluir(@Param('id') int id) async {
    await _service.excluir(id);
    return Response(204);
  }

  @ApiOperation(summary: 'Ativar usuario')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Put('/<id>/ativar')
  Future<UsuarioDto> ativar(@Param('id') int id) async
    => await _service.ativar(id);

  @ApiOperation(summary: 'Desativar usuario')
  @ApiSecurity(['bearer'])
  @UseGuards([JwtGuard])
  @Put('/<id>/desativar')
  Future<UsuarioDto> desativar(@Param('id') int id) async
    => await _service.desativar(id);
}



/* 

import 'package:backend/modules/auth/guards/jwt_guard.dart';
import 'package:backend/modules/usuario/dtos/usuario_dto.dart';
import 'package:backend/modules/usuario/services/usuario_service.dart';
import 'package:vaden/vaden.dart';


@UseGuards([JwtGuard])
@Api(tag: "usuarios", description: "Gestão de usuários")
@Controller("/usuarios")
class UsuarioController {
final UsuarioService _service;
UsuarioController(this._service);

@ApiOperation(summary: "Listar todos")
@Get("/") Future<List<UsuarioDto>> listar() => _service.listarTodos();


@ApiOperation(summary: "Buscar por ID")
@Get("/<id>") Future<UsuarioDto> buscar(@Param("id") int id)
=> _service.buscarPorId(id);


@ApiOperation(summary: "Criar usuário")
@Post("/") Future<UsuarioDto> criar(@Body() CriarUsuarioDto dto)
=> _service.criar(dto);


@ApiOperation(summary: 'Ativa usuario')
@ApiSecurity(['bearer'])
@UseGuards([JwtGuard])
@Put('/<id>/ativar')
Future<UsuarioDto> ativar(@Param('id') int id) async {
  return await _service.ativar(id);
}

@ApiOperation(summary: 'Desativa usuario')
@ApiSecurity(['bearer'])
@UseGuards([JwtGuard])
@Put('/<id>/desativar')
Future<UsuarioDto> desativar(@Param('id') int id) async {
  return await _service.desativar(id);
}



@ApiOperation(summary: "Excluir usuário")
@Delete("/<id>")
Future<Response> excluir(@Param("id") int id) async {
await _service.excluir(id);
return Response(204);
}
} */