import 'dart:async';
import 'dart:io';

import 'package:backend/modules/auth/services/auth_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:vaden/vaden.dart';
@Component()
class JwtGuard extends VadenGuard {
final AuthService _auth;
JwtGuard(this._auth);

 String get _secret =>
    Platform.environment['JWT_SECRET'] ?? 'fallback_local';

    
@override
  @override
  FutureOr<bool> canActivate(Request request) {
    final h = request.headers['authorization'];
    if (h == null || !h.startsWith('Bearer ')) return false;
    try {
      JWT.verify(h.substring(7), SecretKey(_secret));
      return true;
    } catch (_) {
      return false;
    }
  }
}