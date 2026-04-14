class TopUpEntity {
  final String reference;
  final String phoneNumber;
  final double amount;
  final String networkId;
  final String networkName;
  final double transferFee;
  final DateTime date;
  final String status; // pending, completed, failed

  const TopUpEntity({
    required this.reference,
    required this.phoneNumber,
    required this.amount,
    required this.networkId,
    required this.networkName,
    required this.transferFee,
    required this.date,
    required this.status,
  });

  double get total => amount + transferFee;
}
