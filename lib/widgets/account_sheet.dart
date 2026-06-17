import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

/// Maps a [FirebaseAuthException] to a localized, user-facing message.
///
/// Wrong password, wrong email, and unknown accounts are deliberately
/// reported with the same generic message: revealing which one was wrong
/// would let an attacker enumerate registered email addresses.
String _authErrorMessage(AppLocalizations l10n, FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return l10n.invalidCredentialsError;
    case 'email-already-in-use':
      return l10n.emailAlreadyInUseError;
    case 'weak-password':
      return l10n.weakPasswordError;
    case 'invalid-email':
      return l10n.emailValidationError;
    case 'network-request-failed':
      return l10n.networkErrorMessage;
    case 'too-many-requests':
      return l10n.tooManyRequestsError;
    case 'user-disabled':
      return l10n.userDisabledError;
    default:
      return l10n.authenticationFailed;
  }
}

/// Bottom sheet, opened from Settings, for signing in/registering, or for
/// viewing the signed-in account and logging out.
///
/// An account is entirely optional - the office locator works fully without
/// signing in.
class AccountSheet extends StatefulWidget {
  const AccountSheet({super.key});

  @override
  State<AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends State<AccountSheet> {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
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

/// Shown when a user is signed in: their email, a themed log-out button, and
/// a delete-account option.
class _SignedInView extends StatefulWidget {
  const _SignedInView({required this.authService, required this.user});

  final AuthService authService;
  final User user;

  @override
  State<_SignedInView> createState() => _SignedInViewState();
}

class _SignedInViewState extends State<_SignedInView> {
  bool _isDeleting = false;
  String? _errorMessage;

  Future<void> _confirmLogout() async {
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
      await widget.authService.signOut();
    }
  }

  /// Prompts for the user's password and re-authenticates with it. The
  /// dialog itself handles empty/incorrect passwords and stays open with an
  /// inline error until the user succeeds or cancels. Returns whether
  /// re-authentication succeeded.
  Future<bool> _reauthenticate() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _ReauthenticateDialog(authService: widget.authService),
    );
    return result ?? false;
  }

  Future<void> _confirmDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(l10n.deleteAccountConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.deleteAccountButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _deleteAccount();
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });
    // Captured before the await: deleting the account triggers the
    // auth-state stream to emit immediately, which swaps this view out for
    // the login form and unmounts this widget before this function resumes.
    // The Navigator itself is still around, so popping through it still
    // closes the sheet even though `this` is no longer mounted.
    final navigator = Navigator.of(context);
    try {
      await widget.authService.deleteAccount();
      navigator.pop(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (!mounted) return;
        final reauthenticated = await _reauthenticate();
        if (reauthenticated) {
          await _deleteAccount();
          return;
        }
      } else {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        setState(() => _errorMessage = _authErrorMessage(l10n, e));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
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
          l10n.accountSignedInAs(widget.user.email ?? ''),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.accountIdLabel(widget.user.uid),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        if (widget.user.metadata.creationTime != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.accountCreatedLabel(
              DateFormat.yMMMd(
                Localizations.localeOf(context).toString(),
              ).format(widget.user.metadata.creationTime!),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: ctaColors(context).background,
            foregroundColor: ctaColors(context).foreground,
          ),
          onPressed: () => _confirmLogout(),
          icon: const Icon(Icons.logout),
          label: Text(l10n.logoutTooltip),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: _isDeleting ? null : () => _confirmDeleteAccount(),
          icon: _isDeleting
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              : const Icon(Icons.delete_outline),
          label: Text(l10n.deleteAccountButton),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

/// Dialog prompting for the user's password before a sensitive action like
/// account deletion. Owns its own [TextEditingController], disposed safely
/// via the widget lifecycle rather than immediately after the dialog closes.
///
/// Handles the re-authentication attempt itself: an empty or incorrect
/// password shows an inline error and keeps the dialog open, instead of
/// dismissing back to the account sheet.
class _ReauthenticateDialog extends StatefulWidget {
  const _ReauthenticateDialog({required this.authService});

  final AuthService authService;

  @override
  State<_ReauthenticateDialog> createState() => _ReauthenticateDialogState();
}

class _ReauthenticateDialogState extends State<_ReauthenticateDialog> {
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = l10n.passwordRequiredError);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await widget.authService.reauthenticateWithPassword(
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = _authErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.reauthenticateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.reauthenticateMessage),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            onSubmitted: _isSubmitting ? null : (_) => _submit(),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancelButton),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Text(l10n.reauthenticateButton),
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
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });
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
      setState(() => _errorMessage = _authErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPasswordReset() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      setState(() {
        _errorMessage = l10n.emailValidationError;
        _infoMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });
    try {
      await widget.authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() => _infoMessage = l10n.passwordResetEmailSent);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = _authErrorMessage(l10n, e));
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
            l10n.authDisclaimerIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.authDisclaimerSync,
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
              prefixIcon: const Icon(Icons.email_outlined),
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
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.passwordValidationError;
              }
              return null;
            },
          ),
          if (!_isRegisterMode) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading ? null : _sendPasswordReset,
                child: Text(l10n.forgotPasswordButton),
              ),
            ),
          ] else
            const SizedBox(height: 8),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (_infoMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _infoMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          const SizedBox(height: 8),
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
                : Text(_isRegisterMode ? l10n.registerButton : l10n.loginTitle),
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
