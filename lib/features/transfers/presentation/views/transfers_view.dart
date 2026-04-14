import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/screens/account_list_screen.dart';
import '../views/screens/create_transfer_screen.dart';
import '../views/screens/transfer_history_screen.dart';

class TransfersView extends ConsumerStatefulWidget {
  const TransfersView({super.key});

  @override
  ConsumerState<TransfersView> createState() => _TransfersViewState();
}

class _TransfersViewState extends ConsumerState<TransfersView> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const AccountListScreen(),
    const CreateTransferScreen(),
    const TransferHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Mis Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Nueva Transferencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }
}

