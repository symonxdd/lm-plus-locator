import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

/// Bottom sheet, opened from Settings, for signing in/registering, or for
/// viewing the signed-in account and logging out.
///
/// An account is entirely optional - the office locator works fully without
/// signing in.
class AccountSheet extends StatelessWidget {
  const AccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<User?>(
          stream: authService.authStateChanges,
          initialData: authService.currentUser,
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              return _EmailAuthForm(authService: authService);
            }
            return _SignedInView(authService: authService, user: user);
          },
        ),
      ),
    );
  }
}

/// Shown when a user is signed in: their email and a themed log-out button.
class _SignedInView extends StatelessWidget {
  const _SignedInView({required this.authService, required this.user});

  final AuthService authService;
  final User user;

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ctaColors(context).background,
              foregroundColor: ctaColors(context).foreground,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.logoutTooltip),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.accountTooltip,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.accountSignedInAs(user.email ?? ''),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: ctaColors(context).background,
            foregroundColor: ctaColors(context).foreground,
          ),
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout),
          label: Text(l10n.logoutTooltip),
        ),
      ],
    );
  }
}

/// Email/password login and registration form, shown when no account is
/// signed in.
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
    return Form(
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
          const SizedBox(height: 8),
          Text(
            l10n.authDisclaimer,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
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
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ctaColors(context).background,
              foregroundColor: ctaColors(context).foreground,
            ),
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ctaColors(context).foreground,
                    ),
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
    );
  }
}
