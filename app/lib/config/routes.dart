import 'package:flutter/material.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/recover_screen.dart';
import '../../screens/main_shell.dart';
import '../../screens/playlist_detail_screen.dart';
import '../../screens/video_player_screen.dart';
import '../../screens/event_detail_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String recover = '/recover';
  static const String main = '/main';
  static const String playlistDetail = '/playlist';
  static const String videoPlayer = '/video';
  static const String eventDetail = '/event';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    recover: (context) => const RecoverScreen(),
    main: (context) => const MainShell(),
  };
}