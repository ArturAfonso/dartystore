

import 'package:vaden/vaden.dart';

@DTO()
class SolicitarResetDto {
final String email;
SolicitarResetDto({required this.email});
}
/* @DTO()
class ConfirmarResetDto {
final String token;
final String novaSenha;
ConfirmarResetDto({required this.token, required this.novaSenha});
} */