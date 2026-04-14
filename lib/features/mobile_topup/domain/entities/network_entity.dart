class NetworkEntity {
  final String id;
  final String name;
  final String icon; // URL o asset path
  final double fee; // Fee de transferencia
  final double minAmount;
  final double maxAmount;

  const NetworkEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.fee,
    required this.minAmount,
    required this.maxAmount,
  });
}
