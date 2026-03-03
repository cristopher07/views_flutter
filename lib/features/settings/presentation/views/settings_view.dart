import '../../../../app/presentation/controllers/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedLanguageCode =
        appLocaleController.value?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 8),
                    Text(
                      localizations.settings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguageCode,
                  decoration: InputDecoration(
                    labelText: localizations.language,
                    filled: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(localizations.english),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text(localizations.spanish),
                    ),
                  ],
                  onChanged: (languageCode) {
                    if (languageCode == null) {
                      return;
                    }
                    appLocaleController.setLanguageCode(languageCode);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
