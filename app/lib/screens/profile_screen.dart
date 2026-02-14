import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadProfile();

    if (profileProvider.user != null) {
      _nameController.text = profileProvider.user!.name;
      _phoneController.text = profileProvider.user?.phone ?? '';
      _birthDateController.text = profileProvider.user?.birthDate ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null && mounted) {
      final profileProvider = context.read<ProfileProvider>();
      final success = await profileProvider.uploadAvatar(File(image.path));

      if (success && mounted) {
        // Update auth provider too
        if (profileProvider.user != null) {
          context.read<AuthProvider>().updateUser(profileProvider.user!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto atualizada com sucesso'),
            backgroundColor: VictusTheme.accentGreen,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    final profileProvider = context.read<ProfileProvider>();
    final data = <String, dynamic>{};

    if (_nameController.text.trim().isNotEmpty) {
      data['name'] = _nameController.text.trim();
    }
    if (_phoneController.text.trim().isNotEmpty) {
      data['phone'] = _phoneController.text.trim();
    }
    if (_birthDateController.text.trim().isNotEmpty) {
      data['birth_date'] = _birthDateController.text.trim();
    }

    if (data.isEmpty) return;

    final success = await profileProvider.updateProfile(data);

    if (success && mounted) {
      setState(() => _isEditing = false);
      if (profileProvider.user != null) {
        context.read<AuthProvider>().updateUser(profileProvider.user!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso'),
          backgroundColor: VictusTheme.accentGreen,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminar sessão'),
        content: const Text('Tens a certeza que queres sair?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VictusTheme.radiusMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: VictusTheme.textLight)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair',
                style: TextStyle(color: VictusTheme.accentRed)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final user = profile.user;

    return Scaffold(
      backgroundColor: VictusTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: VictusTheme.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_isEditing) {
                        _saveProfile();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isEditing
                            ? VictusTheme.primaryPink
                            : VictusTheme.primaryPinkLight,
                        borderRadius:
                            BorderRadius.circular(VictusTheme.radiusSmall),
                      ),
                      child: Text(
                        _isEditing ? 'Guardar' : 'Editar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isEditing
                              ? Colors.white
                              : VictusTheme.primaryPinkDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Avatar
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VictusTheme.primaryPinkLight,
                      border: Border.all(
                        color: VictusTheme.primaryPink.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: user?.avatar != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${ApiConfig.baseUrl}${user!.avatar}',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              errorWidget: (_, __, ___) => _defaultAvatar(user),
                            )
                          : _defaultAvatar(user),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: VictusTheme.primaryPink,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Name
              Text(
                user?.name ?? '',
                style: VictusTheme.heading2,
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: VictusTheme.bodySmall,
              ),

              const SizedBox(height: 32),

              // Form fields
              if (profile.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      color: VictusTheme.primaryPink),
                )
              else ...[
                CustomTextField(
                  label: 'Nome',
                  hint: 'O teu nome',
                  controller: _nameController,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Telefone',
                  hint: '+351 912 345 678',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Data de nascimento',
                  hint: 'YYYY-MM-DD',
                  controller: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  enabled: _isEditing,
                ),
              ],

              const SizedBox(height: 40),

              // Logout & other options
              _buildOptionTile(
                icon: Icons.lock_outline,
                title: 'Alterar palavra-passe',
                onTap: () {
                  // Navigate to change password screen
                },
              ),
              _buildOptionTile(
                icon: Icons.help_outline,
                title: 'Ajuda e Suporte',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.description_outlined,
                title: 'Termos e Condições',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Política de Privacidade',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: VictusTheme.accentRed),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(VictusTheme.radiusLarge),
                    ),
                  ),
                  child: const Text(
                    'Terminar sessão',
                    style: TextStyle(
                      color: VictusTheme.accentRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar(dynamic user) {
    return Center(
      child: Text(
        (user?.name ?? 'U')[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: VictusTheme.primaryPink,
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: VictusTheme.divider.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: VictusTheme.textMedium, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: VictusTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: VictusTheme.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}