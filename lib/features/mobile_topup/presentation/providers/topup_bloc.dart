import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_topup_usecase.dart';
import 'topup_event.dart';
import 'topup_state.dart';

/// BLoC para manejar TopUp
class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  final CreateTopUpUseCase _createTopUpUseCase;

  String _phoneNumber = '';
  String? _selectedNetworkId;
  double? _selectedAmount;

  TopUpBloc({required CreateTopUpUseCase createTopUpUseCase})
      : _createTopUpUseCase = createTopUpUseCase,
        super(const TopUpInitial()) {
    // Registrar manejadores de eventos
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<NetworkSelected>(_onNetworkSelected);
    on<AmountSelected>(_onAmountSelected);
    on<SubmitTopUpRequested>(_onSubmitTopUpRequested);
    on<ResetTopUpState>(_onResetTopUpState);
  }

  /// Manejar cambio de número de teléfono
  Future<void> _onPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<TopUpState> emit,
  ) async {
    _phoneNumber = event.phoneNumber;
    _emitFormUpdated(emit);
  }

  /// Manejar selección de red
  Future<void> _onNetworkSelected(
    NetworkSelected event,
    Emitter<TopUpState> emit,
  ) async {
    _selectedNetworkId = event.networkId;
    _emitFormUpdated(emit);
  }

  /// Manejar selección de monto
  Future<void> _onAmountSelected(
    AmountSelected event,
    Emitter<TopUpState> emit,
  ) async {
    _selectedAmount = event.amount;
    _emitFormUpdated(emit);
  }

  /// Manejar envío de formulario
  Future<void> _onSubmitTopUpRequested(
    SubmitTopUpRequested event,
    Emitter<TopUpState> emit,
  ) async {
    if (!_isFormValid()) {
      emit(const TopUpError(message: 'Por favor completa todos los campos'));
      return;
    }

    emit(const TopUpLoading());

    try {
      final result = await _createTopUpUseCase.call(
        phoneNumber: _phoneNumber,
        networkId: _selectedNetworkId!,
        amount: _selectedAmount!,
      );

      emit(TopUpSuccess(topUp: result));
    } catch (e) {
      emit(TopUpError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Manejar reset de estado
  Future<void> _onResetTopUpState(
    ResetTopUpState event,
    Emitter<TopUpState> emit,
  ) async {
    _phoneNumber = '';
    _selectedNetworkId = null;
    _selectedAmount = null;
    emit(const TopUpReset());
    emit(const TopUpInitial());
  }

  /// Método auxiliar para emitir estado de formulario actualizado
  void _emitFormUpdated(Emitter<TopUpState> emit) {
    emit(TopUpFormUpdated(
      phoneNumber: _phoneNumber,
      selectedNetworkId: _selectedNetworkId,
      selectedAmount: _selectedAmount,
    ));
  }

  /// Verificar si el formulario es válido
  bool _isFormValid() {
    return _phoneNumber.isNotEmpty &&
        _selectedNetworkId != null &&
        _selectedAmount != null;
  }
}
