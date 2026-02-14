import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } else if (mounted && auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: VictusTheme.accentRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: VictusTheme.pinkGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // Back button & Title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: VictusTheme.textDark,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Entra na tua conta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: VictusTheme.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24), // Balance
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Email field
                    CustomTextField(
                      label: 'Email',
                      hint: 'exemploemail@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Insere o teu email';
                        }
                        if (!val.contains('@')) return 'Email inválido';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    CustomTextField(
                      label: 'Palavra-passe',
                      hint: 'Inserir palavra-passe',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Insere a tua palavra-passe';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Login button
                    PrimaryButton(
                      text: 'Entrar',
                      onPressed: _login,
                      isLoading: auth.isLoading,
                    ),

                    const SizedBox(height: 20),

                    // Recover
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Esqueceste-te da palavra-passe? ',
                          style: VictusTheme.bodySmall.copyWith(fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.recover),
                          child: Text(
                            'Recuperar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: VictusTheme.textLink,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tens conta? ',
                          style: VictusTheme.bodySmall.copyWith(fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.register),
                          child: Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: VictusTheme.textLink,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Terms
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: VictusTheme.bodySmall.copyWith(fontSize: 12),
                        children: [
                          const TextSpan(text: 'Ao utilizares a Victus, aceitas os nossos\n'),
                          TextSpan(
                            text: 'Termos',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: VictusTheme.textDark,
                            ),
                          ),
                          const TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: VictusTheme.textDark,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}