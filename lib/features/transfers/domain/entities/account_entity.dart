class AccountEntity {
  final String id;
  final String accountNumber;
  final String accountHolder;
  final double balance;
  final String accountType; // checking, savings
  final String bankName;

  const AccountEntity({
    required this.id,
    required this.accountNumber,
    required this.accountHolder,
    required this.balance,
    required this.accountType,
    required this.bankName,
  });
}
