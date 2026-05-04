import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:vaden/vaden.dart';

@Service()
class EmailService {

  Future<void> enviarResetSenha(String email, String token) async {
    final smtpServer = SmtpServer(
      Platform.environment['SMTP_HOST'] ?? '',
      port: int.parse(Platform.environment['SMTP_PORT'] ?? '587'),
      username: Platform.environment['SMTP_USER'],
      password: Platform.environment['SMTP_PASS'],
    );

    // Monte a URL que seu app Flutter vai abrir para confirmar o reset
    final resetUrl = 'https://seuapp.com/reset-senha?token=$token';

    final message = Message()
      ..from = Address(Platform.environment['SMTP_USER'] ?? '')
      ..recipients.add(email)
      ..subject = 'Redefinição de senha'
      ..text = 'Clique no link para redefinir sua senha:\n\n$resetUrl\n\n'
                'O link expira em 1 hora.';

    await send(message, smtpServer);
  }
}