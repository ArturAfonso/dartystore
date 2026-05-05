## Plan: Projeto Web Flutter (Portfólio)

TL;DR - O objetivo é criar um web app em Flutter que consuma uma API REST (backend em Vaden). Vou apresentar duas alternativas de arquitetura recomendadas (Clean Architecture enxuta e Feature-first), detalhar passos de implementação, arquivos relevantes, verificação e trade-offs. A decisão final da stack (HTTP lib, DI, estado) será sua; o plano assume preferências: rotas nomeadas (`go_router`), evitar `GetX` como solicitado.

**Steps**
1. Escolher arquitetura e confirmar decisões de bibliotecas (DI, HTTP, estado, router) — *depends on 1* (paralela com 2 opcional)
2. Atualizar `pubspec.yaml` com dependências escolhidas (ex.: `go_router`, `dio` ou `http`, `get_it`, `flutter_bloc` ou `riverpod`) — *depends on 1*
3. Esboçar estrutura de pastas (scaffold) conforme arquitetura escolhida — *depends on 1,2*
4. Implementar container de DI e registro de serviços (`get_it`) — *depends on 3*
5. Implementar cliente HTTP (wrapper) com tratamento de erros, timeouts e logging — *depends on 4*
6. Implementar repositórios e modelos de dados (serialização) — *depends on 5*
7. Implementar camada de domínio (use cases) se usar Clean Architecture — *depends on 6*
8. Implementar BLoCs (ou outra solução de estado escolhida) para presentation layer — *depends on 6/7*
9. Configurar roteamento com `go_router` (rotas nomeadas, deep links, web URL sync) — *parallel with 8*
10. Implementar temas e centralizar sistema de cores (usar hex do Figma) — *parallel with 8/9*
11. Testes unitários para repositórios e BLoCs; testes de widget para páginas críticas — *depends on 6/8*
12. Preparar build web e documentação de deploy (ex.: GitHub Pages) — *depends on 9/10/11*

**Relevant files**
- [lib/main.dart](lib/main.dart#L1-L400) — refatorar para delegar `MyApp` para `lib/src/app.dart` e inicializar DI/router
- lib/src/app.dart — entrada do app (inicialização do router e temas)
- lib/src/di/injector.dart — registrar dependências e fábricas
- lib/src/services/api_client.dart — wrapper do HTTP (Dio/Http)
- lib/src/data/repositories/* — repositórios (ex.: product_repository.dart)
- lib/src/data/models/* — modelos / DTOs e serialização
- lib/src/domain/usecases/* — (Clean) regras de negócio
- lib/src/features/* — páginas, BLoCs, widgets por feature
- lib/src/routes/app_router.dart — definição do `GoRouter` com rotas nomeadas
- lib/src/theme/app_theme.dart — tema, tipografia e função para converter hex para `Color`

**Verification**
1. `flutter analyze` sem novos avisos relevantes na área modificada
2. Testes unitários: repositório e BLoC com cobertura mínima nas regras principais
3. Rodar `flutter run -d chrome` e verificar rotas (URL muda conforme navega), temas e chamadas à API (ver respostas/erros tratados)
4. Verificar build web com `flutter build web` e preview (serve) localmente

**Decisions / Assunções**
- Router sugerido: `go_router` (boa integração web e rotas nomeadas). Alternativa: `auto_route` se quiser geração de código.
- Injeção de dependência: `get_it` (simples e amplamente adotado). Alternativa: `riverpod` (oferece DI + estado reativo) se preferir evitar `get_it`.
- HTTP: `dio` recomendado por interceptors, facilidade para logging e retry; `http` é mais leve se preferir simplicidade.
- Estado: `flutter_bloc` é minha recomendação padrão (claro, testável). Alternativa leve: `provider` ou `riverpod` (mais moderno).

**Further Considerations**
1. Converter cores hex do Figma: criar utilitário `hexToColor(String hex)` em `app_theme.dart` e expor um `AppColors` central com nomes semânticos.
2. Tratamento de erros: padronizar `ApiException` e mapear códigos HTTP em repositório para mensagens amigáveis.
3. Build e deploy: para portfolio web, recomendar GitHub Pages, Netlify ou Vercel. Incluir instruções de CI (GitHub Actions) opcional.

---

## Alternativa A — Clean Architecture (enxuta)

Resumo: separa em camadas (presentation, domain, data) mas evita excesso de files/boilerplate criando boundaries claras e implementando apenas o necessário para cada feature.

Estrutura proposta (exemplo mínimo):
- lib/src/features/<feature>/presentation/<pages, bloc, widgets>
- lib/src/features/<feature>/domain/<entities, usecases>
- lib/src/features/<feature>/data/<models, repositories_impl>
- lib/src/core/<api_client, exceptions, utils, di, theme>

Vantagens:
- Testabilidade clara (usecases e repositórios testáveis isoladamente)
- Boa separação de responsabilidades, facil manutenção quando o app cresce
- Facil de expandir (bom para projeto que pode evoluir)

Desvantagens:
- Mais arquivos e camadas mesmo para features pequenas
- Leve overhead inicial (mais boilerplate) — você pode torná-la "enxuta" evitando gerar classes para features triviais

Quando usar: ideal se você quer demonstrar padrões profissionais de arquitetura no portfólio e quer código bem organizado mesmo para crescimento futuro.

## Alternativa B — Feature-first (mais enxuta)

Resumo: organiza por feature com pasta por feature contendo tudo (presentation, data, models). Menos rigidez de camadas, mais prática e rápida para apps pequenos.

Estrutura proposta (exemplo):
- lib/src/features/<feature>/widgets/
- lib/src/features/<feature>/screens/
- lib/src/features/<feature>/data/<models, repository_impl>
- lib/src/core/<api_client, di, theme>

Vantagens:
- Simplicidade e velocidade de desenvolvimento
- Fácil de navegar para desenvolvedores que trabalham feature-a-feature
- Menos boilerplate — ideal para protótipos e portfólios

Desvantagens:
- Menos rigidez na separação de responsabilidades (pode virar bagunça se o projeto crescer)
- Testes de domínio menos evidentes separadamente (mas ainda perfeitamente possíveis)

Quando usar: ótimo para o seu caso (app de mostruário/portfólio) se preferir escrever mais código produtivo e manter estrutura limpa por feature.

---

**Recomendação final**
- Para seu portfólio: eu recomendo começar com a **Feature-first** (mais enxuta) e aplicar princípios do Clean (ex.: separar repositórios e usar usecases quando fizer sentido). Isso dá um bom trade-off entre velocidade e disciplina arquitetural.
- Stack sugerida inicial: `go_router`, `dio`, `get_it`, `flutter_bloc` (ou `riverpod` se preferir menos ceremony)

**Próximo passo**
- Confirme qual das duas arquiteturas prefere (Clean enxuta ou Feature-first) e qual combinação de libs prefere para DI/HTTP/estado (ex.: `get_it` + `dio` + `flutter_bloc`).
- Depois da sua confirmação, eu atualizo a `memória` com o plano final e proponho o scaffold de arquivos (lista de arquivos a criar) — eu não gerarei código além do scaffold, salvo seu pedido explícito.

