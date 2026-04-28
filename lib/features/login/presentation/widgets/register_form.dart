import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/register_providers.dart';
import '../providers/register_notifier.dart';
import '../providers/register_state.dart';

class RegisterForm extends ConsumerStatefulWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterForm({
    super.key,
    this.onRegisterSuccess,
  });

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscuredPassword = true;
  bool _obscuredConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerNotifierProvider);
    final themeApp = Theme.of(context);
    final schemeColorApp = themeApp.colorScheme;

    // Listener para mostrar errores
    ref.listen<RegisterState>(registerNotifierProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          if (previous?.maybeWhen(error: (_) => null, orElse: () => null) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: schemeColorApp.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        orElse: () {},
      );
    });

    // Determinar si está cargando
    final isLoading = registerState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crear Cuenta',
            style: themeApp.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completa el formulario para registrarte',
            style: themeApp.textTheme.bodyMedium?.copyWith(
              color: schemeColorApp.outline,
            ),
          ),
          const SizedBox(height: 32),
          // Nombre
          TextField(
            controller: _firstNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Juan',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          // Apellido
          TextField(
            controller: _lastNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Apellido',
              hintText: 'Pérez',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          // Teléfono
          TextField(
            controller: _phoneController,
            enabled: !isLoading,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Teléfono',
              hintText: '+1234567890',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 16),
          // Email
          TextField(
            controller: _emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
              hintText: 'juan@example.com',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          // Contraseña
          TextField(
            controller: _passwordController,
            enabled: !isLoading,
            obscureText: _obscuredPassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: '••••••••',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscuredPassword = !_obscuredPassword;
                  });
                },
                icon: Icon(
                  _obscuredPassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Confirmar Contraseña
          TextField(
            controller: _confirmPasswordController,
            enabled: !isLoading,
            obscureText: _obscuredConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
              hintText: '••••••••',
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscuredConfirmPassword = !_obscuredConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscuredConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Botón Registrar
          FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    ref.read(registerNotifierProvider.notifier).register(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        );
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        schemeColorApp.onPrimary,
                      ),
                    ),
                  )
                : const Text('Registrarse'),
          ),
          const SizedBox(height: 16),
          // Link a login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta? '),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Inicia sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: schemeColorApp.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
