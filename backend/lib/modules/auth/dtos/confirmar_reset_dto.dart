import 'package:lucid_validation/lucid_validation.dart';
import 'package:vaden/vaden.dart';

class ConfirmarResetDtoValidator extends LucidValidator<ConfirmarResetDto> {
  ConfirmarResetDtoValidator() {
    ruleFor((d) => d.token, key: 'token').notEmpty();
    ruleFor((d) => d.novaSenha, key: 'novaSenha').notEmpty().minLength(6);
  }
}

@DTO()
class ConfirmarResetDto with Validator<ConfirmarResetDto> {
  final String token;
  final String novaSenha;
  const ConfirmarResetDto(this.token, this.novaSenha);

  @override
  LucidValidator<ConfirmarResetDto> validate(
    ValidatorBuilder<ConfirmarResetDto> b) => ConfirmarResetDtoValidator();
}