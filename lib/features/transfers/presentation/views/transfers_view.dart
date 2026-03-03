import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class TransfersView extends StatelessWidget {
  const TransfersView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Text(localizations.transfers),
    );
  }
}
