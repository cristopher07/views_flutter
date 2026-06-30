class AccountSummaryEntity {
  final String id;
  final String type;
  final String number;
  final String owner;
  final double balance;

  const AccountSummaryEntity({
    required this.id,
    required this.type,
    required this.number,
    required this.owner,
    required this.balance,
  });
}
