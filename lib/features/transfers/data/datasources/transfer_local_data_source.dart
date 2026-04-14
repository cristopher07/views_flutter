import '../../domain/entities/account_entity.dart';
import '../../domain/entities/transfer_entity.dart';

abstract class TransferLocalDataSource {
  Future<List<AccountEntity>> getAccounts();
  Future<TransferEntity> createTransfer({
    required String accountFromId,
    required String accountToId,
    required double amount,
  });
  Future<List<TransferEntity>> getTransferHistory();
}

class TransferLocalDataSourceImpl implements TransferLocalDataSource {
  // Simulamos una base de datos local con 4 cuentas hardcodeadas
  final List<AccountEntity> _accounts = [
    const AccountEntity(
      id: 'ACC001',
      accountNumber: '1234567890',
      accountHolder: 'Juan Pérez',
      balance: 5000.0,
      accountType: 'checking',
      bankName: 'Banco Nacional',
    ),
    const AccountEntity(
      id: 'ACC002',
      accountNumber: '0987654321',
      accountHolder: 'María García',
      balance: 3500.0,
      accountType: 'savings',
      bankName: 'Banco Nacional',
    ),
    const AccountEntity(
      id: 'ACC003',
      accountNumber: '1111222233',
      accountHolder: 'Carlos López',
      balance: 7200.0,
      accountType: 'checking',
      bankName: 'Banco Regional',
    ),
    const AccountEntity(
      id: 'ACC004',
      accountNumber: '4444555566',
      accountHolder: 'Ana Martínez',
      balance: 2100.0,
      accountType: 'savings',
      bankName: 'Banco Regional',
    ),
  ];

  final List<TransferEntity> _transferHistory = [];

  @override
  Future<List<AccountEntity>> getAccounts() async {
    // Simulamos un delay de carga de 1 segundo
    await Future.delayed(const Duration(seconds: 1));
    return _accounts;
  }

  @override
  Future<TransferEntity> createTransfer({
    required String accountFromId,
    required String accountToId,
    required double amount,
  }) async {
    // Simulamos un delay de 2 segundos para procesar la transferencia
    await Future.delayed(const Duration(seconds: 2));

    // Validar que las cuentas existan y tengan saldo
    final accountFrom = _accounts.firstWhere(
      (acc) => acc.id == accountFromId,
      orElse: () => throw Exception('Cuenta origen no encontrada'),
    );

    if (accountFrom.balance < amount) {
      throw Exception('Saldo insuficiente');
    }

    // Crear transferencia
    final transfer = TransferEntity(
      reference: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      accountFrom: accountFromId,
      accountTo: accountToId,
      date: DateTime.now(),
      status: 'completed',
    );

    // Guardar en historial (en una app real, esto iría a una BD)
    _transferHistory.add(transfer);

    return transfer;
  }

  @override
  Future<List<TransferEntity>> getTransferHistory() async {
    // Simulamos un delay de carga
    await Future.delayed(const Duration(milliseconds: 500));
    return _transferHistory;
  }
}
