import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/usecases/create_transfer_use_case.dart';
import '../providers/transfer_providers.dart';

class TransferState {
  final bool isLoading;
  final TransferEntity? transfer;
  final String? error;

  const TransferState({
    this.isLoading = false,
    this.transfer,
    this.error,
  });

  TransferState copyWith({
    bool? isLoading,
    TransferEntity? transfer,
    String? error,
  }) {
    return TransferState(
      isLoading: isLoading ?? this.isLoading,
      transfer: transfer ?? this.transfer,
      error: error ?? this.error,
    );
  }
}

class TransferNotifier extends StateNotifier<TransferState> {
  final CreateTransferUseCase _createTransferUseCase;

  TransferNotifier(this._createTransferUseCase) : super(const TransferState());

  Future<void> createTransfer(
    String accountFromId,
    String accountToId,
    double amount,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Este delay de 2 segundos ya está en el datasource
      final transfer = await _createTransferUseCase.call(
        accountFromId: accountFromId,
        accountToId: accountToId,
        amount: amount,
      );
      state = state.copyWith(isLoading: false, transfer: transfer);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al realizar la transferencia: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = const TransferState();
  }
}

final transferNotifierProvider = StateNotifierProvider<TransferNotifier, TransferState>((ref) {
  final useCase = ref.watch(createTransferUseCaseProvider);
  return TransferNotifier(useCase);
});

