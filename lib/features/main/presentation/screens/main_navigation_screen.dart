import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../diet_plan/presentation/screens/diet_plan_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../scanner/presentation/screens/scanner_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _hideBottomBar = false;

  final List<IconData> _activeIcons = const [
    Icons.home_rounded,
    Icons.restaurant_menu_rounded,
    Icons.camera_alt_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  final List<IconData> _inactiveIcons = const [
    Icons.home_outlined,
    Icons.restaurant_menu_outlined,
    Icons.camera_alt_outlined,
    Icons.bar_chart_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const DietPlanScreen(),
      ScannerScreen(
        onScanStateChanged: (isScanned) {
          setState(() {
            _hideBottomBar = isScanned;
          });
        },
        onNavigateToHome: () {
          setState(() {
            _currentIndex = 0;
            _hideBottomBar = false;
          });
        },
      ),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: BottomBar(
        showIcon: false,
        layout: const BottomBarLayout(
          width: 314,
          offset: 24,
          borderRadius: BorderRadius.all(Radius.circular(33)),
          alignment: Alignment.bottomCenter,
        ),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(33),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        scrollBehavior: const BottomBarScrollBehavior(
          hideOnScroll: false,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        child: _hideBottomBar
            ? const SizedBox.shrink()
            : SizedBox(
                width: 314,
                height: 66,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final isSelected = index == _currentIndex;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          if (index != 2) {
                            _hideBottomBar = false;
                          }
                        });
                      },
                      child: SizedBox(
                        width: 58,
                        height: 66,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF5A16)
                                      .withValues(alpha: 0.15)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSelected
                                  ? _activeIcons[index]
                                  : _inactiveIcons[index],
                              color: isSelected
                                  ? const Color(0xFFFF5A16)
                                  : const Color(0xFF474747),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
      ),
    );
  }
}

