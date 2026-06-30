import 'app/presentation/controllers/locale_controller.dart';
import 'app/router/app_router.dart';
import 'core/environmet/env.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

void main() {
  Env.environment = Environment.development;
  runProject();
}

void runProject() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Env.initialize();
  await controllerLocaleApp.loadSavedLocale();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: controllerLocaleApp,
      builder: (context, locale, _) {
        return Consumer(
          builder: (context, ref, child) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              onGenerateTitle:
                  (context) => AppLocalizations.of(context)!.titleApp,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFFFCC00),
                  primary: Colors.black,
                  secondary: const Color(0xFFFFCC00),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFFFCC00),
                  foregroundColor: Colors.black,
                  centerTitle: false,
                ),
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFFFFCC00),
                  ),
                ),
              ),
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
