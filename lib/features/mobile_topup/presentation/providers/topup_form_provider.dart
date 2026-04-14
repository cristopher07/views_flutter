import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/topup_entity.dart';
import '../../domain/usecases/create_topup_usecase.dart';
import 'topup_providers.dart';

class TopUpFormState {
  final String phoneNumber;
  final String? selectedNetworkId;
  final double? selectedAmount;
  final bool isLoading;
  final TopUpEntity? topUpResult;
  final String? error;

  const TopUpFormState({
    this.phoneNumber = '',
    this.selectedNetworkId,
    this.selectedAmount,
    this.isLoading = false,
    this.topUpResult,
    this.error,
  });

  TopUpFormState copyWith({
    String? phoneNumber,
    String? selectedNetworkId,
    double? selectedAmount,
    bool? isLoading,
    TopUpEntity? topUpResult,
    String? error,
  }) {
    return TopUpFormState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedNetworkId: selectedNetworkId ?? this.selectedNetworkId,
      selectedAmount: selectedAmount ?? this.selectedAmount,
      isLoading: isLoading ?? this.isLoading,
      topUpResult: topUpResult ?? this.topUpResult,
      error: error ?? this.error,
    );
  }

  bool get isFormValid =>
      phoneNumber.isNotEmpty && selectedNetworkId != null && selectedAmount != null;
}

class TopUpFormNotifier extends StateNotifier<TopUpFormState> {
  final CreateTopUpUseCase _createTopUpUseCase;

  TopUpFormNotifier(this._createTopUpUseCase) : super(const TopUpFormState());

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber, error: null);
  }

  void setSelectedNetwork(String networkId) {
    state = state.copyWith(selectedNetworkId: networkId, error: null);
  }

  void setSelectedAmount(double amount) {
    state = state.copyWith(selectedAmount: amount, error: null);
  }

  Future<void> submitTopUp() async {
    if (!state.isFormValid) {
      state = state.copyWith(error: 'Por favor completa todos los campos');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _createTopUpUseCase.call(
        phoneNumber: state.phoneNumber,
        networkId: state.selectedNetworkId!,
        amount: state.selectedAmount!,
      );

      state = state.copyWith(
        isLoading: false,
        topUpResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const TopUpFormState();
  }
}

final topUpFormProvider = StateNotifierProvider<TopUpFormNotifier, TopUpFormState>((ref) {
  final useCase = ref.watch(createTopUpUseCaseProvider);
  return TopUpFormNotifier(useCase);
});
