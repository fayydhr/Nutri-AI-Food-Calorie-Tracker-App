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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final topPadding =
                  (screenHeight * 0.11).clamp(24.0, 105.0);
              final imageHeight =
                  (screenHeight * 0.35).clamp(180.0, 364.0);
              final gapUnderImage =
                  (screenHeight * 0.07).clamp(16.0, 97.0);
              final buttonScale =
                  (screenHeight / 844.0).clamp(0.85, 1.0);

              return Stack(
                children: [
                  // Content responsif dengan scroll cadangan
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: topPadding),

                          // assets\png\OB2.png (tinggi responsif)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: imageHeight,
                              maxWidth: 260,
                            ),
                            child: Image.asset(
                              AppAssets.ob2,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: gapUnderImage),

                          // Title: Track Everything That Matters
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Track Everything That\nMatters',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: (screenHeight < 700) ? 24 : 28,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF121212),
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Log calories, macros, water, and activity — \nall in one place.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: (screenHeight < 700) ? 15 : 17,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF121212)
                                    .withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          ),

                          // Ruang untuk tombol bawah
                          SizedBox(height: 188 * buttonScale + 20),
                        ],
                      ),
                    ),
                  ),

                  // Di paling bawah tengah: assets\png\Ellipse 13.png
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.scale(
                        scale: buttonScale,
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<OnboardingBloc>()
                                .add(OnboardingNextPressed());
                          },
                          child: SizedBox(
                            width: 212,
                            height: 188,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.ellipse13,
                                  width: 212,
                                  height: 188,
                                  fit: BoxFit.contain,
                                ),
                                Container(
                                  width: 94,
                                  height: 94,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF121212),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
