import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myhealthapp/screens/splash_screen.dart';
import 'package:myhealthapp/screens/onboarding_screen.dart';
import 'package:myhealthapp/screens/auth_screen.dart';
import 'package:myhealthapp/screens/otp_screen.dart';
import 'package:myhealthapp/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHealthApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF4511E),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4511E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/auth': (context) => AuthScreen(),
        '/otp': (context) => const OTPScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}