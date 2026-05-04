class UsuarioInterno {
  final int id;
  final String nome;
  final String email;
  final String senhaHash;
  final bool ativo;

  UsuarioInterno({
    required this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    required this.ativo,
  });
}