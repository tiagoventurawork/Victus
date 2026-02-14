import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({super.key});

  @override
  State<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _recover() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.recover(_emailController.text.trim());

    if (success && mounted) {
      setState(() => _sent = true);
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
                          'Recuperar conta',
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
                  const SizedBox(height: 60),

                  if (!_sent) ...[
                    Text(
                      'Insere o teu email para receberes instruções de recuperação da palavra-passe.',
                      textAlign: TextAlign.center,
                      style: VictusTheme.bodyMedium,
                    ),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Enviar',
                      onPressed: _recover,
                      isLoading: auth.isLoading,
                    ),
                  ] else ...[
                    const Icon(
                      Icons.mark_email_read_outlined,
                      size: 64,
                      color: VictusTheme.primaryPink,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Email enviado!',
                      style: VictusTheme.heading2,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Se o email existir na nossa base de dados, receberás instruções de recuperação.',
                      textAlign: TextAlign.center,
                      style: VictusTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Voltar ao login',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}