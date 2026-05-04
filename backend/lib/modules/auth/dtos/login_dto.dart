import 'package:vaden/vaden.dart';

class LoginValidator extends LucidValidator<LoginDto> {
LoginValidator() {
ruleFor((d) => d.email, key: "email").notEmpty();
ruleFor((d) => d.senha, key: "senha").notEmpty().minLength(6);
}
}
@DTO()
class LoginDto with Validator<LoginDto> {
final String email;
final String senha;
const LoginDto(this.email, this.senha);
@override
LucidValidator<LoginDto> validate(ValidatorBuilder<LoginDto> b)
=> LoginValidator();
}
