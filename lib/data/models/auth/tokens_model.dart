class TokensModel{
  final String id;
  final String user_id;
  final String token_hash;
  final String token_hype;
  final DateTime? expiresAt;
  final bool is_revoked;
  final DateTime createdAt;
  final DateTime revokedAt;

  TokensModel({
    required this.id,
    required this.user_id,
    required this.token_hash,
    required this.token_hype,
    this.expiresAt,
    required this.is_revoked,
    required this.createdAt, 
    required this.revokedAt,
  });

}