
import 'package:vaden/vaden.dart';


@DTO()
class ProdutoDto {
final int id;
final String nome;
final double preco;
final bool ativo;
ProdutoDto({required this.id, required this.nome,
required this.preco, required this.ativo});
}
class CriarProdutoValidator extends LucidValidator<CriarProdutoDto> {
CriarProdutoValidator() {
ruleFor((d) => d.nome, key: "nome").notEmpty().minLength(3);
ruleFor((d) => d.preco, key: "preco").greaterThan(0);
}
}
@DTO()
class CriarProdutoDto with Validator<CriarProdutoDto> {
final String nome;
final double preco;
const CriarProdutoDto(this.nome, this.preco);
@override
LucidValidator<CriarProdutoDto> validate(
ValidatorBuilder<CriarProdutoDto> b) => CriarProdutoValidator();
}
@DTO()
class AtualizarProdutoDto {
final String nome;
final double preco;
AtualizarProdutoDto({required this.nome, required this.preco});
}