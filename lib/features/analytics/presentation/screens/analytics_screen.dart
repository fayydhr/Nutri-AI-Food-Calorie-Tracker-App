import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedFilterIndex = 0; // 0: All Diets, 1: My Diets

  final List<String> _filters = const ['All Diets', 'My Diets'];

  // Simulated API Diet Data
  final List<Map<String, String>> _allDiets = const [
    {
      'title': 'Keto Clean Energy Meal Plan',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      'kcal': '480',
      'protein': '32g',
      'carbs': '12g',
      'fat': '34g',
    },
    {
      'title': 'High Protein Muscle Gain',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80',
      'kcal': '650',
      'protein': '55g',
      'carbs': '45g',
      'fat': '18g',
    },
    {
      'title': 'Mediterranean Balanced Bowl',
      'image':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
      'kcal': '520',
      'protein': '28g',
      'carbs': '50g',
      'fat': '22g',
    },
    {
      'title': 'Low Carb Plant Power',
      'image':
          'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=800&q=80',
      'kcal': '390',
      'protein': '22g',
      'carbs': '35g',
      'fat': '16g',
    },
  ];

  final List<Map<String, String>> _myDiets = const [
    {
      'title': 'My Daily Lean Protein Goal',
      'image':
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=800&q=80',
      'kcal': '580',
      'protein': '48g',
      'carbs': '38g',
      'fat': '14g',
    },
    {
      'title': 'My Morning Power Bowl',
      'image':
          'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=800&q=80',
      'kcal': '410',
      'protein': '26g',
      'carbs': '48g',
      'fat': '12g',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentDiets = _selectedFilterIndex == 0 ? _allDiets : _myDiets;

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
                  // Title: Diets
                  Text(
                    'Diets',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Sizebox 36
                  const SizedBox(height: 36),

                  // Filter Container (White, H49, Radius 30)
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
                                        : const Color(0xFF121212),
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

                  // Banner Container (Color DDC0FF, Radius 24)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDC0FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Diet Plans',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF121212),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Personalized plans to match your goals and lifestyle.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1E1E1E),
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sizebox 20
                  const SizedBox(height: 20),

                  // Header: Diets
                  Text(
                    'Diets',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Sizebox 20
                  const SizedBox(height: 20),

                  // Diets List from API data
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentDiets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final item = currentDiets[index];
                      return _buildDietCard(
                        title: item['title']!,
                        imageUrl: item['image']!,
                        kcal: item['kcal']!,
                        protein: item['protein']!,
                        carbs: item['carbs']!,
                        fat: item['fat']!,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDietCard({
    required String title,
    required String imageUrl,
    required String kcal,
    required String protein,
    required String carbs,
    required String fat,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image H220, Corner Radius 24
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: double.infinity,
            height: 220,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2C2C2C),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: Color(0xFFFF5A16),
                      size: 48,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFF1E1E1E),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF5A16),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Sizebox 12
        const SizedBox(height: 12),

        // Title (Space Grotesk, Semibold 18, White)
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 6),

        // Subtitle: Kcal | Protein | Carbs | Fat (Space Grotesk, Regular 17, White)
        Text(
          '$kcal Kcal | Protein: $protein | Carbs: $carbs | Fat: $fat',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

