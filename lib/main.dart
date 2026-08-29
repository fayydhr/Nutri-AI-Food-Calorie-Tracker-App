import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/google_login_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NutriAiApp());
}

class NutriAiApp extends StatelessWidget {
  const NutriAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection setup (Clean Architecture)
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository =
        AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    final loginUseCase = LoginUseCase(authRepository);
    final signupUseCase = SignupUseCase(authRepository);
    final googleLoginUseCase = GoogleLoginUseCase(authRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) => SplashBloc(),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
            googleLoginUseCase: googleLoginUseCase,
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
