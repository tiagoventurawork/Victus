import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _nameController.text.trim(),
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
        decoration: const BoxDecoration(gradient: VictusTheme.pinkGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: VictusTheme.textDark),
                      ),
                      const Expanded(
                        child: Text(
                          'Criar conta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: VictusTheme.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    label: 'Nome',
                    hint: 'O teu nome',
                    controller: _nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Insere o teu nome';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Email',
                    hint: 'exemploemail@gmail.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Insere o teu email';
                      if (!val.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Palavra-passe',
                    hint: 'Mínimo 6 caracteres',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Confirmar palavra-passe',
                    hint: 'Repete a palavra-passe',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'As palavras-passe não coincidem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Criar conta',
                    onPressed: _register,
                    isLoading: auth.isLoading,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Já tens conta? ',
                          style: VictusTheme.bodySmall.copyWith(fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: VictusTheme.textLink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}