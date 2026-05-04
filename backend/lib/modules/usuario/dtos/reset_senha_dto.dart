import 'package:lucid_validation/lucid_validation.dart';
import 'package:vaden/vaden.dart';

class ResetSenhaDtoValidator extends LucidValidator<ResetSenhaDto> {
  ResetSenhaDtoValidator() {
    ruleFor((d) => d.email, key: 'email').notEmpty();
  }
}

@DTO()
class ResetSenhaDto with Validator<ResetSenhaDto> {
  final String email;
  const ResetSenhaDto(this.email);

  @override
  LucidValidator<ResetSenhaDto> validate(
    ValidatorBuilder<ResetSenhaDto> b) => ResetSenhaDtoValidator();
}