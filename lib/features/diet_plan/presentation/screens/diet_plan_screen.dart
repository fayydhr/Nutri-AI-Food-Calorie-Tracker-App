import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

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
                bottom: 36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Daily Diet Plan',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Personalized meals based on your calorie target',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Meal Cards
                  _buildMealCard(
                    title: 'Breakfast',
                    calories: '420 kcal',
                    time: '08:00 AM',
                    foodName: 'Oatmeal with Berries & Almonds',
                    badgeColor: const Color(0xFFF5F378),
                    icon: Icons.wb_sunny_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    title: 'Lunch',
                    calories: '650 kcal',
                    time: '01:00 PM',
                    foodName: 'Grilled Chicken Salad & Avocado',
                    badgeColor: const Color(0xFF45C588),
                    icon: Icons.restaurant_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    title: 'Snack',
                    calories: '180 kcal',
                    time: '04:30 PM',
                    foodName: 'Greek Yogurt with Walnuts',
                    badgeColor: const Color(0xFFDDC0FF),
                    icon: Icons.cookie_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    title: 'Dinner',
                    calories: '520 kcal',
                    time: '07:30 PM',
                    foodName: 'Baked Salmon with Steamed Broccoli',
                    badgeColor: const Color(0xFFFF6F43),
                    icon: Icons.nightlight_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required String calories,
    required String time,
    required String foodName,
    required Color badgeColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: badgeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: const Color(0xFF71717A),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF27272A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calories,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            foodName,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFE4E4E7),
            ),
          ),
        ],
      ),
    );
  }
}
