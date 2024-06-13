class Balances{
  final int idBalance;
  final String nim;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Balances({
    required this.idBalance,
    required this.nim,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt
  });

  factory Balances.fromJson(Map<String, dynamic> json) => Balances(
    idBalance: json['id_balance'] as int,
    nim: json['nim'] as String,
    balance: json['balance'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] != null 
    ? DateTime.parse(json['deleted_at'] as String)
    : null
  );
}