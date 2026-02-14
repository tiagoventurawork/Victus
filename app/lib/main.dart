import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/library_provider.dart';
import 'providers/video_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const VictusApp());
}

class VictusApp extends StatelessWidget {
  const VictusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Victus',
        debugShowCheckedModeBanner: false,
        theme: VictusTheme.themeData,
        home: const AuthGate(),
        routes: AppRoutes.routes,
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();
    await auth.checkAuth();
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: VictusTheme.backgroundPink,
        body: const Center(
          child: CircularProgressIndicator(color: VictusTheme.primaryPink),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();
    return auth.isAuthenticated ? const MainShell() : const LoginScreen();
  }
}