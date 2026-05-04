/* 


import 'package:backend/modules/auth/controllers/auth_controller.dart';
import 'package:backend/modules/auth/guards/jwt_guard.dart';
import 'package:backend/modules/auth/services/auth_service.dart';
import 'package:backend/modules/auth/services/email_service.dart';
import 'package:backend/modules/usuario/services/senha_service.dart';
import 'package:vaden/vaden.dart';

@VadenModule([
  AuthController,
  AuthService,
  EmailService,
 
  JwtGuard,
])
class AuthModule {} */