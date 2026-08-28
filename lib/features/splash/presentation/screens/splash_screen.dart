import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          if (state.isFirstTime) {
            Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: SizedBox.expand(
          child: Stack(
            children: [
              // Bottom Image: Group 22.png (lebar penuh kanan-kiri)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    AppAssets.splashBottom,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              // Content: Logo & Tagline (padding atas 156, center)
              Positioned(
                top: 156,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo SVG
                      SvgPicture.asset(
                        AppAssets.logoSvg,
                        width: 162,
                        height: 54,
                      ),
                      const SizedBox(height: 40),

                      // Baris 1: Eating [Healthy]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Eating ',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 36 / 24,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                          Container(
                            width: 114,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6F43),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Healthy',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Baris 2: made easy!
                      Text(
                        'made easy!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 36 / 24,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
