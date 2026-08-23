import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_indicator.dart';
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                if (state.isLastPage) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () {
                    context.read<OnboardingBloc>().add(OnboardingSkipPressed());
                  },
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    context
                        .read<OnboardingBloc>()
                        .add(OnboardingPageChanged(index));
                  },
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingIndicator(
                          count: state.totalPages,
                          currentIndex: state.currentPage,
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: state.isLastPage
                              ? AppStrings.getStarted
                              : AppStrings.next,
                          onPressed: () {
                            context
                                .read<OnboardingBloc>()
                                .add(OnboardingNextPressed());
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
