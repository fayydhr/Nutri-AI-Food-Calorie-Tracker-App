import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step3_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String onboardingStep1 = '/onboarding/step1';
  static const String onboardingStep2 = '/onboarding/step2';
  static const String onboardingStep3 = '/onboarding/step3';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        onboardingStep1: (context) => const Scaffold(body: SafeArea(child: OnboardingStep1Screen())),
        onboardingStep2: (context) => const Scaffold(body: SafeArea(child: OnboardingStep2Screen())),
        onboardingStep3: (context) => const Scaffold(body: SafeArea(child: OnboardingStep3Screen())),
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        home: (context) => const HomeScreen(),
      };
}
