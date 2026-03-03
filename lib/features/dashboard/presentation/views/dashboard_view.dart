
import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Text(localizations.dashboard),
    );
  }
}
