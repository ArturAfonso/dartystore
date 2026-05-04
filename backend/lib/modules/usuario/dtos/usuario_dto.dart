// usuario_dto.dart — resposta
import 'package:vaden/vaden.dart';

@DTO()
class UsuarioDto {
final int id;
final String nome;
final String email;
final bool ativo;
UsuarioDto({required this.id, required this.nome,
required this.email, required this.ativo});
}
// criar_usuario_dto.dart — entrada com validação
class CriarUsuarioValidator extends LucidValidator<CriarUsuarioDto> {
CriarUsuarioValidator() {
ruleFor((d) => d.nome, key: "nome").notEmpty().minLength(3);
ruleFor((d) => d.email, key: "email").notEmpty();
ruleFor((d) => d.senha, key: "senha").notEmpty().minLength(6);
}
}
@DTO()
class CriarUsuarioDto with Validator<CriarUsuarioDto> {
final String nome;
final String email;
final String senha;
const CriarUsuarioDto(this.nome, this.email, this.senha);
@override
LucidValidator<CriarUsuarioDto> validate(
ValidatorBuilder<CriarUsuarioDto> b) => CriarUsuarioValidator();
}
// atualizar_usuario_dto.dart — edição parcial
@DTO()
class AtualizarUsuarioDto {
final String? nome;
final String? email;
AtualizarUsuarioDto({this.nome, this.email});
}