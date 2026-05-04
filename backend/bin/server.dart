import 'package:backend/vaden_application.dart';
import "package:dotenv/dotenv.dart";
import 'package:vaden/vaden.dart';

Future<void> main(List<String> args) async {
  DotEnv(includePlatformEnvironment: true).load();
  final vaden = VadenApp();
  await vaden.setup();
  final server = await vaden.run(args);
  print('Server listening on port ${server.port}');
}

