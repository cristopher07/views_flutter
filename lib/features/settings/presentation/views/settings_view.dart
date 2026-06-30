import '../../../../app/presentation/controllers/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text(
              localizations.settings,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.language,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<Locale?>(
              valueListenable: controllerLocaleApp,
              builder: (context, locale, _) {
                final codeLanguageSelected =
                    locale?.languageCode ??
                    Localizations.localeOf(context).languageCode;

                return SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: 'es',
                      label: Text(localizations.spanish),
                    ),
                    ButtonSegment<String>(
                      value: 'en',
                      label: Text(localizations.english),
                    ),
                  ],
                  selected: {codeLanguageSelected},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) {
                    controllerLocaleApp.codeLanguageSet(selection.first);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
