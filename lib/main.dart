import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/devices_screen.dart';
import 'screens/security_screen.dart';
import 'screens/entertainment_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/cameras_screen.dart';
import 'screens/access_control_screen.dart';
import 'screens/music_screen.dart';
import 'screens/gaming_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/help_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/report_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const ProviderScope(child: AuraHome()));
}

class AuraHome extends ConsumerWidget {
  const AuraHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'AuraHome',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/auth',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/rooms': (ctx) => const RoomsScreen(),
        '/devices': (ctx) => const DevicesScreen(),
        '/security': (ctx) => const SecurityScreen(),
        '/entertainment': (ctx) => const EntertainmentScreen(),
        '/settings': (ctx) => const SettingsScreen(),
        '/auth': (ctx) => const WelcomeScreen(),
        '/cameras': (ctx) => const CamerasScreen(),
        '/access': (ctx) => const AccessControlScreen(),
        '/music': (ctx) => const MusicScreen(),
        '/gaming': (ctx) => const GamingScreen(),
        '/notifications': (ctx) => const NotificationsScreen(),
        '/help': (ctx) => const HelpScreen(),
        '/profile': (ctx) => const ProfileScreen(),
        '/report': (ctx) => const ReportScreen(),
      },
    );
  }
}
