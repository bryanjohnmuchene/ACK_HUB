import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_client.dart';
import 'auth_controller.dart';
import 'church_onboarding.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey<FormState> _form;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _registering = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _form = GlobalKey<FormState>();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  Future<void> _submit() async { if (!_form.currentState!.validate()) return; if (_registering) { final profile = await Navigator.of(context).push<ChurchProfile>(MaterialPageRoute(builder: (_) => const ChurchOnboarding())); if (profile == null) return; await _withError(() => context.read<AuthController>().register({'email': _email.text.trim(), 'password': _password.text, 'firstName': profile.firstName, 'lastName': profile.lastName, ...profile.churchIds})); } else { await _withError(() => context.read<AuthController>().login(_email.text.trim(), _password.text)); } }
  Future<void> _withError(Future<void> Function() action) async { setState(() => _busy = true); try { await action(); } on ApiException catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message))); } finally { if (mounted) setState(() => _busy = false); } }
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.church, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'ACK Hub',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _registering
                            ? 'Join your digital church community'
                            : 'Welcome back to your digital church home',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                        ),
                        validator: (v) => v != null && v.contains('@')
                            ? null
                            : 'Enter a valid email',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (v) => v != null && v.length >= 12
                            ? null
                            : 'Use at least 12 characters',
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  _registering
                                      ? 'Continue to church details'
                                      : 'Sign in',
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => setState(
                                  () => _registering = !_registering,
                                ),
                        child: Text(
                          _registering
                              ? 'Already have an account? Sign in'
                              : 'New to ACK Hub? Create an account',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
