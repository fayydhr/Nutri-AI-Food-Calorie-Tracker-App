import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class OnboardingStep2Screen extends StatelessWidget {
  const OnboardingStep2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF45C588),
      child: Stack(
        children: [
          // Content dengan scroll agar responsif di berbagai ukuran layar
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding atas 105
                  const SizedBox(height: 105),

                  // assets\png\OB2.png
                  Image.asset(
                    AppAssets.ob2,
                    width: 260,
                    height: 364,
                    fit: BoxFit.contain,
                  ),

                  // size box 97
                  const SizedBox(height: 97),

                  // Track Everything That Matters (Space Grotesk, semibold, 28)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Track Everything That\nMatters',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF121212),
                        height: 1.25,
                      ),
                    ),
                  ),

                  // sizebox 12
                  const SizedBox(height: 12),

                  // Subtitle (Space Grotesk, regular, 17)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Log calories, macros, water, and activity — \nall in one place.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF121212).withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Ruang untuk tombol bawah agar tidak tumpang tindih saat di-scroll
                  const SizedBox(height: 210),
                ],
              ),
            ),
          ),

          // Di paling bawah tengah: assets\png\Ellipse 13.png
          // Dalem nya ada lingkaran 121212 dan isinya Next Space Grotesk semibold 18
          // dan bawahnya ada arrow ke kanan
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  context.read<OnboardingBloc>().add(OnboardingNextPressed());
                },
                child: SizedBox(
                  width: 212,
                  height: 188,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // assets\png\Ellipse 13.png
                      Image.asset(
                        AppAssets.ellipse13,
                        width: 212,
                        height: 188,
                        fit: BoxFit.contain,
                      ),

                      // Lingkaran 121212
                      Container(
                        width: 94,
                        height: 94,
                        decoration: const BoxDecoration(
                          color: Color(0xFF121212),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
