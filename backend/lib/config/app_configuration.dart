import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bean()
  Future<Connection> database(ApplicationSettings s) async {
    final conn = await Connection.open(Endpoint(
      host:  Platform.environment["DB_HOST"] ?? s["database"]["host"], 
      port: int.parse(Platform.environment["DB_PORT"] ?? s["database"]["port"].toString()),
      database: Platform.environment["DB_NAME"] ?? s["database"]["database"],
      username: Platform.environment["DB_USER"] ?? s["database"]["username"],
      password: Platform.environment["DB_PASSWORD"] ?? s["database"]["password"],
      ),
      settings:  const ConnectionSettings(sslMode: SslMode.disable));
    print("■ Banco conectado!");
    return conn;
  }

  @Bean()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline() //
        .addMiddleware(cors(allowedOrigins: ['*']))
        .addVadenMiddleware(EnforceJsonContentType())
        .addMiddleware(logRequests());
  }
}
