import 'package:equatable/equatable.dart';
import '../../domain/entities/topup_entity.dart';

/// Estado base para TopUp
abstract class TopUpState extends Equatable {
  const TopUpState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TopUpInitial extends TopUpState {
  const TopUpInitial();
}

/// Estado de formulario actualizado
class TopUpFormUpdated extends TopUpState {
  final String phoneNumber;
  final String? selectedNetworkId;
  final double? selectedAmount;

  const TopUpFormUpdated({
    required this.phoneNumber,
    this.selectedNetworkId,
    this.selectedAmount,
  });

  @override
  List<Object?> get props => [phoneNumber, selectedNetworkId, selectedAmount];
}

/// Estado de carga
class TopUpLoading extends TopUpState {
  const TopUpLoading();
}

/// Estado de éxito
class TopUpSuccess extends TopUpState {
  final TopUpEntity topUp;

  const TopUpSuccess({required this.topUp});

  @override
  List<Object?> get props => [topUp];
}

/// Estado de error
class TopUpError extends TopUpState {
  final String message;

  const TopUpError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado reset
class TopUpReset extends TopUpState {
  const TopUpReset();
}
