import 'package:equatable/equatable.dart';

/// Evento base para las transferencias
abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para crear una transferencia
class CreateTransferRequested extends TransferEvent {
  final String accountFromId;
  final String accountToId;
  final double amount;

  const CreateTransferRequested({
    required this.accountFromId,
    required this.accountToId,
    required this.amount,
  });

  @override
  List<Object?> get props => [accountFromId, accountToId, amount];
}

/// Evento para resetear estado
class ResetTransferState extends TransferEvent {
  const ResetTransferState();
}
