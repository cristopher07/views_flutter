import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_state.dart';
import 'register_notifier.dart';

/// Provider del Notifier de Registro
final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});
