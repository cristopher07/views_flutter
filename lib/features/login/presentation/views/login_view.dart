import '../../../../core/assets.dart';
import '../../../../app/presentation/views/home_tabs_view.dart';
import '../../../../core/environmet/env.dart';
import '../providers/login_provider.dart';
import '../widgets/social_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final schemeColorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: schemeColorTheme.surfaceBright,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 210,
                  width: double.infinity,
                  child: Image.asset(
                    Assets.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const BodyWidget(),
          ],
        ),
      ),
    );
  }
}

class BodyWidget extends ConsumerStatefulWidget {
  const BodyWidget({super.key});

  @override
  ConsumerState<BodyWidget> createState() => _BodyWidgetState();
}

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialWidget.google(),
        const SizedBox(width: 16),
        SocialWidget.apple(),
        const SizedBox(width: 16),
        SocialWidget.facebook(),
      ],
    );
  }
}

class _BodyWidgetState extends ConsumerState<BodyWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscuredPasswordIs = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeApp = Theme.of(context);
    final schemeColorApp = themeApp.colorScheme;
    final loginState = ref.watch(loginProvider);

    // Listener para navegar cuando login es exitoso
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.isAuthenticated && previous?.isAuthenticated != true) {
        // Login exitoso, navegar a home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const HomeTabsView(),
          ),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Env.nameApp,
            style: themeApp.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),

          // Email TextField
          TextField(
            controller: _emailController,
            enabled: !loginState.isLoading,
            decoration: InputDecoration(
              hintText: localizations.addressEmail,
              filled: true,
              border: const OutlineInputBorder(),
              errorText: loginState.error != null
                  ? loginState.error
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Password TextField
          TextField(
            controller: _passwordController,
            enabled: !loginState.isLoading,
            obscureText: _obscuredPasswordIs,
            decoration: InputDecoration(
              hintText: localizations.password,
              filled: true,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscuredPasswordIs ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscuredPasswordIs = !_obscuredPasswordIs;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(localizations.passwordForgot),
            ),
          ),
          const SizedBox(height: 12),

          // Login Button
          FilledButton(
            onPressed: loginState.isLoading
                ? null
                : () {
                    ref.read(loginProvider.notifier).login(
                          _emailController.text,
                          _passwordController.text,
                        );
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: loginState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(localizations.login),
          ),
          const SizedBox(height: 16),

          // Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${localizations.memberNot} '),
              TextButton(
                onPressed: () {
                  debugPrint('Navigate to Sign Up');
                },
                child: Text(
                  localizations.nowRegister,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: schemeColorApp.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Text(
            localizations.withContinueOr,
            textAlign: TextAlign.center,
            style: themeApp.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const SocialMedia(),
        ],
      ),
    );
  }
}
