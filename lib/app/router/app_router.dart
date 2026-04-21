import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/mobile_topup/presentation/views/mobile_topup_view.dart';
import '../../features/mobile_topup/presentation/views/screens/confirmation_screen.dart';
import '../../features/mobile_topup/presentation/views/screens/transfer_successful_screen.dart';
import '../../features/mobile_topup/presentation/views/screens/receipt_screen.dart';
import '../../features/transfers/presentation/views/transfers_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
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
