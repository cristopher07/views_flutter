import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';
import 'login_notifier.dart';

/// Provider principal para el router y estado global
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

/// Provider auxiliar para verificar si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(
    success: (user, email) => true,
    orElse: () => false,
  );
});

/// Provider auxiliar para obtener el usuario actual
final currentUserProvider = Provider<String?>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(
    success: (user, email) => user,
    orElse: () => null,
  );
});
