import 'package:equatable/equatable.dart';

/// Evento base para TopUp
abstract class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para actualizar número de teléfono
class PhoneNumberChanged extends TopUpEvent {
  final String phoneNumber;

  const PhoneNumberChanged({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Evento para seleccionar red
class NetworkSelected extends TopUpEvent {
  final String networkId;

  const NetworkSelected({required this.networkId});

  @override
  List<Object?> get props => [networkId];
}

/// Evento para seleccionar monto
class AmountSelected extends TopUpEvent {
  final double amount;

  const AmountSelected({required this.amount});

  @override
  List<Object?> get props => [amount];
}

/// Evento para enviar formulario
class SubmitTopUpRequested extends TopUpEvent {
  const SubmitTopUpRequested();
}

/// Evento para resetear estado
class ResetTopUpState extends TopUpEvent {
  const ResetTopUpState();
}
