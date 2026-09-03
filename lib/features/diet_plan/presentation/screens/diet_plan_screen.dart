import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  int _selectedFilterIndex = 0; // 0: Daily, 1: Weekly, 2: Monthly

  final List<String> _filters = const ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 14,
                left: 20,
                right: 20,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Analysis',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Sizebox 36
                  const SizedBox(height: 36),

                  // Nutrition Analysis Banner (H128, Color 45C588, Radius 24)
                  Container(
                    width: double.infinity,
                    height: 128,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF45C588),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Nutrition Analysis',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF121212),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Track trends. Spot patterns. Crush\nyour goals.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1E1E1E),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sizebox 24
                  const SizedBox(height: 24),

                  // Filter Toggle Container (White, H49, Corner Radius 30)
                  Container(
                    width: double.infinity,
                    height: 49,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = index == _selectedFilterIndex;
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _selectedFilterIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 37,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF5A16)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  _filters[index],
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 17,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF555555),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Sizebox 24
                  const SizedBox(height: 24),

                  // Calorie Trends Card (Color DDC0FF, H273, Corner Radius 24)
                  Container(
                    width: double.infinity,
                    height: 273,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDC0FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calorie Trends',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF121212),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Graph Section with Y-Axis, 2-color Bars & X-Axis
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Y-Axis Labels
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildYLabel('400'),
                                  _buildYLabel('300'),
                                  _buildYLabel('200'),
                                  _buildYLabel('100'),
                                  _buildYLabel('  0'),
                                ],
                              ),
                              const SizedBox(width: 10),

                              // Graph Area
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final chartHeight = constraints.maxHeight - 24;
                                    const maxKcal = 400.0;

                                    final daysData = [
                                      {'day': 'Mo', 'kcal': 320.0, 'isOver': false},
                                      {'day': 'Tu', 'kcal': 440.0, 'isOver': true},
                                      {'day': 'We', 'kcal': 280.0, 'isOver': false},
                                      {'day': 'Th', 'kcal': 350.0, 'isOver': false},
                                      {'day': 'Fr', 'kcal': 420.0, 'isOver': true},
                                      {'day': 'Sa', 'kcal': 310.0, 'isOver': false},
                                      {'day': 'Su', 'kcal': 260.0, 'isOver': false},
                                    ];

                                    return Column(
                                      children: [
                                        // Bars Area
                                        SizedBox(
                                          height: chartHeight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: daysData.map((data) {
                                              final kcal = data['kcal'] as double;
                                              final isOver = data['isOver'] as bool;
                                              final barHeight =
                                                  (kcal / maxKcal * chartHeight)
                                                      .clamp(10.0, chartHeight);

                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                width: 16,
                                                height: barHeight,
                                                decoration: BoxDecoration(
                                                  color: isOver
                                                      ? const Color(0xFF121212)
                                                      : const Color(0xFFFF5A16),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // X-Axis Day Labels (2-letter English)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: daysData.map((data) {
                                            return Text(
                                              data['day'] as String,
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF333333),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Legend Section
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF5A16),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '5 days under goals',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF121212),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF121212),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '2 days over by >200kcal',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF121212),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sizebox 24
                  const SizedBox(height: 24),

                  // Macro Distribution Card (Color F5F378, H198, Corner Radius 24)
                  Container(
                    width: double.infinity,
                    height: 198,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F378),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Macro Distribution',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF121212),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "You're consistently low on protein.",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),

                        // Sizebox 24
                        const SizedBox(height: 20),

                        // 3 Boxes (W108, H88, Corner Radius 16)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMacroBox(
                              title: 'Fats',
                              color: const Color(0xFFDDC0FF),
                              textColor: const Color(0xFF121212),
                            ),
                            _buildMacroBox(
                              title: 'Carbs',
                              color: const Color(0xFF45C588),
                              textColor: const Color(0xFF121212),
                            ),
                            _buildMacroBox(
                              title: 'Protein',
                              color: const Color(0xFFFF6F43),
                              textColor: Colors.white,
                            ),
                          ],
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
    );
  }

  Widget _buildYLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF4A4A4A),
      ),
    );
  }

  Widget _buildMacroBox({
    required String title,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: 104,
      height: 84,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

