import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedDayIndex;
  late List<Map<String, String>> _daysOfWeek;

  @override
  void initState() {
    super.initState();
    _initCurrentWeek();
  }

  void _initCurrentWeek() {
    final now = DateTime.now();
    // Senin sebagai hari pertama dalam minggu (now.weekday: 1=Mon .. 7=Sun)
    final monday = now.subtract(Duration(days: now.weekday - 1));
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    _daysOfWeek = List.generate(7, (index) {
      final date = monday.add(Duration(days: index));
      return {
        'day': dayNames[index],
        'date': date.day.toString().padLeft(2, '0'),
      };
    });

    // Otomatis memilih tanggal hari ini
    _selectedDayIndex = now.weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final photoUrl = currentUser?.photoURL;

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
                top: 8,
                left: 20,
                right: 20,
                bottom: 36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header: Profile Picture & "Good Morning" + Right Crown & Notification buttons
                  Row(
                    children: [
                      // Avatar Profile (44x44)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF27272A),
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? Image.network(
                                photoUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Teks Good Morning
                      Text(
                        'Good Morning',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),

                      // Crown Button (lingkaran gelap)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Notification Bell Button (lingkaran gelap)
                      GestureDetector(
                        onTap: () {
                          // Opsi logout saat long press atau tap
                          _showAccountMenu(context);
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // sizebox 24
                  const SizedBox(height: 24),

                  // Container Hari dan Tanggal (H110, warna putih, corner radius 28)
                  Container(
                    height: 110,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_daysOfWeek.length, (index) {
                        final isSelected = index == _selectedDayIndex;
                        final dayItem = _daysOfWeek[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isSelected ? 46 : 42,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFDDC0FF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Nama Hari
                                Text(
                                  dayItem['day']!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF121212),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Tanggal: jika terpilih dibungkus lingkaran hitam 121212 dengan teks putih
                                isSelected
                                    ? Container(
                                        width: 34,
                                        height: 34,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF121212),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          dayItem['date']!,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 34,
                                        height: 34,
                                        alignment: Alignment.center,
                                        child: Text(
                                          dayItem['date']!,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF121212),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // sizebox 24
                  const SizedBox(height: 24),

                  // Count Your Daily Calories, Space Grotesk, semibold 24
                  Text(
                    'Count Your Daily Calories',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // sizebox 20
                  const SizedBox(height: 20),

                  // Container H229, DDC0FF, corner radius 24
                  Container(
                    height: 229,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDC0FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kiri atas: Calories, Space Grotesk, semibold, 20
                        Text(
                          'Calories',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF121212),
                          ),
                        ),

                        // Tengah bawah: Parameter 0-100 dengan buletan 1672 Left
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 190,
                              height: 165,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Lengkungan Arc Parameter 0 - 100 Tebal
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: const _ArcGaugePainter(
                                        progress: 0.53,
                                      ),
                                    ),
                                  ),

                                  // Buletan di dalam (W: 121.12, H: 121.12)
                                  Container(
                                    width: 121.12,
                                    height: 121.12,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.90),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '1672',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF121212),
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Left',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF121212),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Label "0" di bawah ujung kiri busur hitam
                                  Positioned(
                                    left: 18,
                                    bottom: 6,
                                    child: Text(
                                      '0',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF121212),
                                      ),
                                    ),
                                  ),

                                  // Label "100" di bawah ujung kanan busur
                                  Positioned(
                                    right: 18,
                                    bottom: 6,
                                    child: Text(
                                      '100',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF121212),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // sizebox 20
                  const SizedBox(height: 20),

                  // 2 Grid: 1 warna F5F378 (Carbs), 1 warna 45C588 (Protein)
                  Row(
                    children: [
                      // Grid 1: Carbs (F5F378)
                      Expanded(
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F378),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Carbs',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF121212),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '140g',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF121212),
                                        ),
                                      ),
                                      Text(
                                        '200g',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF474747),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: 140 / 200,
                                      minHeight: 8,
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.7),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF121212),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Grid 2: Protein (45C588)
                      Expanded(
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF45C588),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Protein',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF121212),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '85g',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF121212),
                                        ),
                                      ),
                                      Text(
                                        '120g',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF474747),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: 85 / 120,
                                      minHeight: 8,
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.7),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF121212),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text(
                    'Log out',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom Painter untuk lengkungan parameter 0-100 kalori
class _ArcGaugePainter extends CustomPainter {
  final double progress; // 0.0 hingga 1.0 (0.5 = 50%)

  const _ArcGaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Ditebalkan sesuai gambar (strokeWidth: 24.0)
    const strokeWidth = 24.0;
    // Radius ke garis tengah busur sehingga pas memeluk lingkaran 121.12 (radius 60.56)
    const radius = 73.5;

    // Sudut lengkungan busur: dari kiri melewati puncak jam 12 ke kanan
    const startAngle = math.pi * 0.85;
    const totalSweep = math.pi * 1.30;

    // Background track lengkungan (transparan lembut sesuai gambar)
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );

    // Active progress arc (warna hitam 121212)
    final activePaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final currentSweep = totalSweep * progress.clamp(0.0, 1.0);
    if (currentSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        currentSweep,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
