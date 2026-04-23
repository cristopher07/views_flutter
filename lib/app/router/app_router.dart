import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/presentation/views/login_view.dart';
import '../../features/login/presentation/providers/login_providers.dart';
import '../../features/mobile_topup/presentation/views/mobile_topup_view.dart';
import '../../features/mobile_topup/presentation/views/screens/confirmation_screen.dart';
import '../../features/mobile_topup/presentation/views/screens/transfer_successful_screen.dart';
import '../../features/mobile_topup/presentation/views/screens/receipt_screen.dart';
import '../../features/transfers/presentation/views/transfers_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    redirect: (context, state) {
      // Si el usuario no está autenticado y no está en /login, redirigir a login
      if (!isAuthenticated && state.uri.path != '/login') {
        return '/login';
      }
      // Si está autenticado y está en /login, redirigir a home
      if (isAuthenticated && state.uri.path == '/login') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MobileTopUpView(),
      ),
      GoRoute(
        path: '/confirmation',
        name: 'confirmation',
        builder: (context, state) => const ConfirmationScreen(),
      ),
      GoRoute(
        path: '/transfer-successful',
        name: 'transfer-successful',
        builder: (context, state) => const TransferSuccessfulScreen(),
      ),
      GoRoute(
        path: '/receipt',
        name: 'receipt',
        builder: (context, state) => const ReceiptScreen(),
      ),
      GoRoute(
        path: '/transfers',
        name: 'transfers',
        builder: (context, state) => const TransfersView(),
      ),
      // Puedes agregar más rutas aquí según necesites
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Ruta no encontrada: ${state.uri}'),
      ),
    ),
  );
});
