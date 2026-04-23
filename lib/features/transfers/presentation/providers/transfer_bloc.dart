import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_transfer_use_case.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

/// BLoC para manejar las transferencias
class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final CreateTransferUseCase _createTransferUseCase;

  TransferBloc({required CreateTransferUseCase createTransferUseCase})
      : _createTransferUseCase = createTransferUseCase,
        super(const TransferInitial()) {
    // Registrar manejadores de eventos
    on<CreateTransferRequested>(_onCreateTransferRequested);
    on<ResetTransferState>(_onResetTransferState);
  }

  /// Manejar evento de crear transferencia
  Future<void> _onCreateTransferRequested(
    CreateTransferRequested event,
    Emitter<TransferState> emit,
  ) async {
    emit(const TransferLoading());

    try {
      final transfer = await _createTransferUseCase.call(
        accountFromId: event.accountFromId,
        accountToId: event.accountToId,
        amount: event.amount,
      );
      emit(TransferSuccess(transfer: transfer));
    } catch (e) {
      emit(TransferError(
        message: 'Error al realizar la transferencia: ${e.toString()}',
      ));
    }
  }

  /// Manejar evento de resetear estado
  Future<void> _onResetTransferState(
    ResetTransferState event,
    Emitter<TransferState> emit,
  ) async {
    emit(const TransferReset());
    emit(const TransferInitial());
  }
}
