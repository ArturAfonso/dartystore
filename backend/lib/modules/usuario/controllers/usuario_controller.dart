

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
}