class TransferEntity {
  final String reference;
  final double amount;
  final String accountFrom;
  final String accountTo;
  final DateTime date;
  final String status; // pending, completed, failed

  const TransferEntity({
    required this.reference,
    required this.amount,
    required this.accountFrom,
    required this.accountTo,
    required this.date,
    required this.status,
  });
}
