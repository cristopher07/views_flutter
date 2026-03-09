import '../../../../app/presentation/controllers/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final codeLanguageSelected =
        controllerLocaleApp.value?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return Center(
      child: Text(
        localizations.settings,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
