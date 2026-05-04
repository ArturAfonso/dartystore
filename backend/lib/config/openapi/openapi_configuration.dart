import 'dart:convert';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';

@Configuration()
class OpenApiConfiguration {
  @Bean()
OpenApi openApi(OpenApiConfig config) {
return OpenApi(
info: Info(
title: "Meu Sistema API",
version: "1.0.0",
description: "API com autenticação JWT",
),
components: Components(
schemas: config.schemas,
securitySchemes: {
"bearer": SecurityScheme.http(
scheme: HttpSecurityScheme.bearer,
bearerFormat: "JWT",
description: "Token obtido em POST /auth/login",
),
},
),
);
}

  @Bean()
  SwaggerUI swaggerUI(OpenApi openApi) {
    return SwaggerUI(
      jsonEncode(openApi.toJson()),
      title: 'backend API',
      docExpansion: DocExpansion.list,
      deepLink: true,
      persistAuthorization: false,
      syntaxHighlightTheme: SyntaxHighlightTheme.agate,
    );
  }

  
}

