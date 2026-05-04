


import 'package:backend/modules/auth/guards/jwt_guard.dart';
import 'package:backend/modules/produto/dtos/produto_dto.dart';
import 'package:backend/modules/produto/services/produto_service.dart';
import 'package:vaden/vaden.dart';

@UseGuards([JwtGuard])
@Api(tag: "produtos", description: "CRUD de produtos")
@Controller("/produtos")
class ProdutoController {
final ProdutoService _service;
ProdutoController(this._service);
@ApiOperation(summary: "Listar todos")
@Get("/") Future<List<ProdutoDto>> listar() => _service.listarTodos();
@ApiOperation(summary: "Buscar por ID")
@Get("/<id>") Future<ProdutoDto> buscar(@Param("id") int id)
=> _service.buscarPorId(id);
@ApiOperation(summary: "Criar produto")
@Post("/") Future<ProdutoDto> criar(@Body() CriarProdutoDto dto)
=> _service.criar(dto);
@ApiOperation(summary: "Editar produto")
@Put("/<id>")
Future<ProdutoDto> editar(@Param("id") int id, @Body() AtualizarProdutoDto dto)
=> _service.editar(id, dto);
@ApiOperation(summary: "Excluir produto")
@Delete("/<id>")
Future<Response> excluir(@Param("id") int id) async {
await _service.excluir(id);
return Response(204);
}
}