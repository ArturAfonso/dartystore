# Dartystore — Backend e Frontend com Vaden

> Projeto exemplo completo (backend + frontend) em Dart/Flutter para testar o framework de backend **Vaden** (pela equipe Fluterando).

Este repositório fornece um backend pronto para uso com endpoints comuns de autenticação e gestão de recursos, além de um frontend Flutter que consome essa API para demonstração e testes.

## Recursos principais

- **Autenticação**: login via email/senha e emissão de token de sessão (token JWT ).
- **Cadastro de usuário**: registrar novos usuários no banco PostgreSQL.
- **Editar e recuperar usuário**: endpoints para atualizar perfil e recuperar dados do usuário.
- **Reset de senha por email**: envio de email com token temporário para redefinição de senha.
- **Produtos simples**: cadastrar e listar produtos (CRUD mínimo).

## Arquitetura e stack

- Backend: Dart + Vaden (estrutura do backend disponível em `backend/`).
- Frontend: Flutter (cliente em `web/` e `lib/` para app multiplataforma).
- Banco de dados: PostgreSQL.
- Email: qualquer SMTP compatível (ex.: Mailtrap, SendGrid, SMTP próprio).
- Deploy: containerização disponível via `Dockerfile` (no diretório `backend/`).

## Estrutura do repositório (resumida)

- `backend/` — implementação do servidor Vaden, configurações, módulos e rotas.
- `web/` e `lib/` — código do cliente Flutter (aplicação que consome a API).

## Variáveis de ambiente (exemplos)

As variáveis abaixo devem ser definidas para o backend:

- `DATABASE_URL` — URL de conexão com o Postgres (ex.: `postgres://user:pass@localhost:5432/dartystore`).
- `JWT_SECRET` — segredo para assinar tokens JWT (ou configuração equivalente do Vaden).
- `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` — configurações do servidor SMTP para envio de emails.
- `RESET_TOKEN_EXPIRATION` — tempo de validade do token de reset (ex.: `3600` segundos).

## Executando localmente

1. Inicie um Postgres localmente (exemplo rápido com Docker):

```
docker run --name dartystore-db -e POSTGRES_PASSWORD=pass -e POSTGRES_USER=user -e POSTGRES_DB=dartystore -p 5432:5432 -d postgres:15
```

2. Defina as variáveis de ambiente (ex.: export `DATABASE_URL`, `SMTP_*`, `JWT_SECRET`).

3. Rodar o backend (dentro de `backend/`):

```
cd backend
dart pub get
dart run bin/server.dart
```

4. Rodar o frontend Flutter (ex.: web):

```
cd web
flutter pub get
flutter run -d chrome
```

## Endpoints principais (exemplos)

- `POST /auth/register` — criar usuário. Payload: `{ "email": "...", "password": "...", "name": "..." }`.
- `POST /auth/login` — autenticar usuário. Retorna token de sessão.
- `GET /users/me` — recuperar dados do usuário autenticado (token requerido).
- `PUT /users/me` — atualizar perfil do usuário autenticado.
- `POST /auth/password-reset/request` — solicitar reset; body: `{ "email": "..." }`. Sistema envia email com token.
- `POST /auth/password-reset/confirm` — confirmar reset; body: `{ "token": "...", "newPassword": "..." }`.
- `POST /products` — criar produto (autenticado se aplicável).
- `GET /products` — listar produtos.

> Observação: rotas exatas e formatos podem variar conforme implementação do `backend/`.

## Fluxo de reset de senha

1. Usuário solicita reset com email.
2. Backend gera token único e temporário, armazena referência (ou hash) e envia link por email.
3. Usuário clica no link, fornece nova senha; backend valida token (expiração) e atualiza a senha no banco.

## Banco de dados e migrações

Implemente as migrações apropriadas para tabelas `users`, `password_resets` e `products`. O projeto já contém exemplos de setup em `backend/config/`.

## Configurações de e-mail

Para testar localmente, serviços como Mailtrap são recomendados. Configure as variáveis `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER` e `SMTP_PASS` antes de iniciar o backend.

## Segurança

- Armazene senhas com hashing forte (ex.: bcrypt, Argon2).
- Tokens de reset devem ser expiráveis e armazenados de forma segura (hash no banco se possível).
- Proteja rotas sensíveis com autenticação e validação de autorização.

## Contribuição

Sugestões, issues e PRs são bem-vindos. Para contribuições:

1. Abra uma issue descrevendo a proposta.
2. Crie um branch, implemente testes e envie um PR para revisão.

## Próximos passos sugeridos

- Implementar CI básico (testes unitários e análise estática para backend e frontend).
- Adicionar `docker-compose.yml` para orquestrar Postgres + backend + frontend.
- Melhorar UX do fluxo de reset no frontend.

---

Se quiser, eu posso: gerar um `docker-compose.yml`, adicionar exemplos de requests (Postman/Insomnia) ou integrar um serviço SMTP de teste. Diga qual próximo passo prefere.
