import '../../../../core/assets.dart';
import '../../../../app/presentation/views/home_tabs_view.dart';
import '../../../../core/environmet/env.dart';
import '../widgets/social_widget.dart';
import 'package:flutter/material.dart';
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

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
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

class _BodyWidgetState extends State<BodyWidget> {
  bool _obscuredPasswordIs = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeApp = Theme.of(context);
    final schemeColorApp = themeApp.colorScheme;

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
          TextField(
            decoration: InputDecoration(
              hintText: localizations.addressEmail,
              filled: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(localizations.passwordForgot),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: Text(localizations.login),
          ),
          const SizedBox(height: 16),
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
