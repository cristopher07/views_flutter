import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/assets.dart';
import '../../../../app/presentation/views/home_tabs_view.dart';
import '../providers/register_providers.dart';
import '../providers/register_notifier.dart';
import '../providers/register_state.dart';
import '../widgets/register_form.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final schemeColorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: schemeColorTheme.surfaceBright,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.asset(
                      Assets.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _BodyWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyWidget extends ConsumerWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final registerState = ref.watch(registerNotifierProvider);

    // Listener para navegar cuando el registro es exitoso
    ref.listen<RegisterState>(registerNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (firstName, lastName, phone, email, password) {
          if (previous?.whenOrNull(success: (_, __, ___, ____, _____) => null) == null) {
            // Mostrar mensaje de éxito y navegar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '¡Bienvenido $firstName! Tu registro fue exitoso.',
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Navegar a home después de 2 segundos
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const HomeTabsView(),
                  ),
                );
              }
            });
          }
        },
      );
    });

    return RegisterForm(
      onRegisterSuccess: () {
        // Callback opcional si es necesario
      },
    );
  }
}
