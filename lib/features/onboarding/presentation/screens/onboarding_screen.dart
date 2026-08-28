import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import 'onboarding_step1_screen.dart';
import 'onboarding_step2_screen.dart';
import 'onboarding_step3_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    OnboardingStep1Screen(),
    OnboardingStep2Screen(),
    OnboardingStep3Screen(),
  ];

  Color _getBackgroundColor(int page) {
    switch (page) {
      case 0:
        return const Color(0xFFDDC0FF); // Lavender (Step 1)
      case 1:
        return const Color(0xFF45C588); // Mint Green (Step 2)
      case 2:
        return const Color(0xFFFF6F43); // Orange (Step 3)
      default:
        return const Color(0xFFDDC0FF);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentPage) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final currentColor = _getBackgroundColor(state.currentPage);

          return Scaffold(
            backgroundColor: currentColor,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (!state.isLastPage)
                  TextButton(
                    onPressed: () {
                      context
                          .read<OnboardingBloc>()
                          .add(OnboardingSkipPressed());
                    },
                    child: const Text(
                      AppStrings.skip,
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
            body: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                context
                    .read<OnboardingBloc>()
                    .add(OnboardingPageChanged(index));
              },
              itemBuilder: (context, index) => _pages[index],
            ),
          );
        },
      ),
    );
  }
}
