import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../widgets/language_selector.dart';

/// The dark navy used for the app icon's pin shape.
const _iconPinColor = Color(0xFF2C398F);

/// Login / register screen supporting email+password auth.
///
/// On successful authentication, [AuthService.authStateChanges] fires and
/// the root widget swaps this screen out for the Home screen automatically.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService();
  bool _isGuestLoading = false;

  Future<void> _continueAsGuest() async {
    setState(() => _isGuestLoading = true);
    try {
      await _authService.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? l10n.authenticationFailed)),
      );
    } finally {
      if (mounted) setState(() => _isGuestLoading = false);
    }
  }

  Future<void> _showEmailAuthSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _EmailAuthForm(authService: _authService),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageSelector()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/icon/icon_foreground.png',
                width: 96,
                height: 96,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _iconPinColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isGuestLoading ? null : _continueAsGuest,
                icon: _isGuestLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.continueAsGuestButton),
              ),
              const Spacer(flex: 3),
              Text(
                l10n.authDisclaimer,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _showEmailAuthSheet,
                child: Text(l10n.continueWithAccountButton),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

/// Email/password login and registration form.
class _EmailAuthForm extends StatefulWidget {
  const _EmailAuthForm({required this.authService});

  final AuthService authService;

  @override
  State<_EmailAuthForm> createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends State<_EmailAuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isRegisterMode) {
        await widget.authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await widget.authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? l10n.authenticationFailed)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isRegisterMode ? l10n.registerTitle : l10n.loginTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return l10n.emailValidationError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return l10n.passwordValidationError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isRegisterMode ? l10n.registerButton : l10n.loginTitle,
                      ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _isRegisterMode = !_isRegisterMode),
                child: Text(
                  _isRegisterMode ? l10n.toggleToLogin : l10n.toggleToRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
