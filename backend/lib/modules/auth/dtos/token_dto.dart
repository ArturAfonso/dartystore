import 'package:vaden/vaden.dart';

@DTO()
class TokenDto {
  final String token;
  final String tipo;
  const TokenDto(this.token, this.tipo);
}
