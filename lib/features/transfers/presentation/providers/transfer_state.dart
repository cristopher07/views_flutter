import 'package:equatable/equatable.dart';
import '../../domain/entities/transfer_entity.dart';

/// Estado base para las transferencias
abstract class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TransferInitial extends TransferState {
  const TransferInitial();
}

/// Estado de carga
class TransferLoading extends TransferState {
  const TransferLoading();
}

/// Estado de éxito
class TransferSuccess extends TransferState {
  final TransferEntity transfer;

  const TransferSuccess({required this.transfer});

  @override
  List<Object?> get props => [transfer];
}

/// Estado de error
class TransferError extends TransferState {
  final String message;

  const TransferError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado reset
class TransferReset extends TransferState {
  const TransferReset();
}
