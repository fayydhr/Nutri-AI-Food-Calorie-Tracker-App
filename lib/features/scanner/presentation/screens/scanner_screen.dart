import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/ai_food_scanner_service.dart';
import '../../../../core/services/nutrition_log_service.dart';

class ScannerScreen extends StatefulWidget {
  final Function(bool isScanned)? onScanStateChanged;
  final VoidCallback? onNavigateToHome;

  const ScannerScreen({
    super.key,
    this.onScanStateChanged,
    this.onNavigateToHome,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isAnalyzing = false;
  Map<String, String>? _scanResult;
  bool _isFavorite = false;

  final NutritionLogService _logService = NutritionLogService();

  @override
  void initState() {
    super.initState();
    _logService.addListener(_onLogUpdated);
  }

  @override
  void dispose() {
    _logService.removeListener(_onLogUpdated);
    super.dispose();
  }

  void _onLogUpdated() {
    if (mounted) setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = image;
        _isAnalyzing = true;
        _scanResult = null;
      });

      // Hide bottom bar when scanning starts
      widget.onScanStateChanged?.call(true);

      final result = await AIFoodScannerService.analyzeFoodImage(File(image.path));

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
        _scanResult = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
      });
      widget.onScanStateChanged?.call(false);

      String errorMessage =
          'Failed to access ${source == ImageSource.camera ? 'camera' : 'gallery'}';
      if (e.toString().contains('channel-error') ||
          e.toString().contains('MissingPluginException')) {
        errorMessage =
            'Please perform a full app restart (rebuild app) to register the newly added Camera/Gallery native plugin.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _logToDailyIntake() {
    final foodName = _scanResult?['foodName'] ?? 'Grilled Chicken & Naan Meal';
    final calStr =
        _scanResult?['calories']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '520';
    final protStr =
        _scanResult?['protein']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '42';
    final carbStr =
        _scanResult?['carbs']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '53';
    final fatStr =
        _scanResult?['fat']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '17';

    final calories = int.tryParse(calStr) ?? 520;
    final protein = int.tryParse(protStr) ?? 42;
    final carbs = int.tryParse(carbStr) ?? 53;
    final fat = int.tryParse(fatStr) ?? 17;

    _logService.addScannedFood(
      foodName: foodName,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      imagePath: _selectedImage?.path,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added $calories kcal ($foodName) to your Daily Intake!',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF45C588),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Reset scanner state & navigate to home
    setState(() {
      _scanResult = null;
      _selectedImage = null;
    });

    widget.onNavigateToHome?.call();
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3F46),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Select Image Source',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const ContainerIcon(
                    icon: Icons.camera_alt_rounded,
                    color: Color(0xFFFF5A16),
                  ),
                  title: Text(
                    'Take a Photo (Camera)',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Divider(color: Color(0xFF2E2E2E)),
                ListTile(
                  leading: const ContainerIcon(
                    icon: Icons.photo_library_rounded,
                    color: Color(0xFF45C588),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    final str = number.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    // If image has been scanned and result is ready, show full result screen
    if (_scanResult != null || _selectedImage != null) {
      return _buildScannedResultView();
    }

    // Otherwise show initial launcher screen with bottom bar visible
    return _buildInitialScannerView();
  }

  Widget _buildInitialScannerView() {
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
                  Text(
                    'AI Food Scanner',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Scan your plate to instantly calculate calories and macros',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Scanner Viewfinder Container / Image Preview
                  GestureDetector(
                    onTap: () => _showPickerOptions(context),
                    child: Container(
                      height: 320,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2E2E2E),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFF5A16)
                                      .withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.center_focus_weak_rounded,
                                  color: Color(0xFFFF5A16),
                                  size: 56,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Tap to capture or upload from gallery',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    color: const Color(0xFFD4D4D8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions Buttons Row
                  Row(
                    children: [
                      // Camera Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Take Photo',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Gallery Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Gallery',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF27272A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFF3F3F46),
                              ),
                            ),
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

  Widget _buildScannedResultView() {
    // Total daily consumption metrics
    final totalCalories = _logService.consumedCalories;
    final calFormatted = _formatNumber(totalCalories);

    // Macro percentages
    final proteinPct = ((_logService.consumedProtein / 80) * 100).clamp(0, 100).toInt();
    final carbsPct = ((_logService.consumedCarbs / 250) * 100).clamp(0, 100).toInt();
    final fatPct = ((_logService.consumedFat / 65) * 100).clamp(0, 100).toInt();

    // Default itemized meal details matching the design screenshot
    final List<Map<String, String>> mealItems = [
      {
        'name': _scanResult?['foodName'] ?? 'Grilled Chicken Strips',
        'cal': _scanResult?['calories'] ?? '220 kcal',
        'protein': _scanResult?['protein'] ?? '30g',
        'carbs': _scanResult?['carbs'] ?? '0g',
        'fat': _scanResult?['fat'] ?? '5g',
      },
      {
        'name': 'Naan Bread',
        'cal': '260 kcal',
        'protein': '7g',
        'carbs': '45g',
        'fat': '6g',
      },
      {
        'name': 'Sautéed Bell Peppers (Red & Yellow)',
        'cal': '40 kcal',
        'protein': '1g',
        'carbs': '8g',
        'fat': '1g',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Gambar Top: W mentok kanan kiri, H 351
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 351,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_selectedImage != null)
                  Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 351,
                  )
                else
                  Image.network(
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 351,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF27272A),
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 64,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      );
                    },
                  ),

                // Top Shadow Gradient for readable icons & status bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 110,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Top Action Controls (Back Arrow & Heart Icon)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 18,
                  right: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button Circle (<)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _scanResult = null;
                            _selectedImage = null;
                          });
                          widget.onScanStateChanged?.call(false);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      // Heart/Favorite Circle (♡)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _isFavorite
                                ? const Color(0xFFFF5A16)
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // AI Analyzing Overlay
                if (_isAnalyzing)
                  Container(
                    color: Colors.black.withValues(alpha: 0.75),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFFF5A16),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Analyzing Food & Macros...',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Black Container Overlapping Image (Starts at top 320, Top Radius 32)
          Positioned.fill(
            top: 320,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF141414),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 4 Nutrient Cards (2x2 Grid, W184 H100 corner radius 16)
                    Row(
                      children: [
                        // Card 1: DDC0FF - Calories
                        Expanded(
                          child: _buildCaloriesCard(
                            title: 'Calories',
                            value: '$calFormatted kcal',
                            color: const Color(0xFFDDC0FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Card 2: 45C588 - Protein with Progress Bar
                        Expanded(
                          child: _buildProgressNutrientCard(
                            title: 'Protein',
                            percentage: proteinPct,
                            color: const Color(0xFF45C588),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Card 3: F5F378 - Carbs with Progress Bar
                        Expanded(
                          child: _buildProgressNutrientCard(
                            title: 'Carbs',
                            percentage: carbsPct,
                            color: const Color(0xFFF5F378),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Card 4: FF6F43 - Fat with Progress Bar
                        Expanded(
                          child: _buildProgressNutrientCard(
                            title: 'Fat',
                            percentage: fatPct,
                            color: const Color(0xFFFF6F43),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Meal Items List
                    ...mealItems.map((item) => _buildMealItemCard(item)),

                    const SizedBox(height: 20),

                    // Bottom Action Button: FF5A16, Add to My Diet (Space Grotesk, 18, semibold, white)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _logToDailyIntake,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add to My Diet',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }

  Widget _buildCaloriesCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressNutrientCard({
    required String title,
    required int percentage,
    required Color color,
  }) {
    final pctClamped = percentage.clamp(0, 100);
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          // Progress Bar Track & Filled line
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pctClamped / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          // Row of % labels e.g. 83% ... 100%
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$pctClamped%',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '100%',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealItemCard(Map<String, String> item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name']!,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  item['cal']!,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFFD4D4D8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('|', style: TextStyle(color: Color(0xFF52525B))),
                ),
                Text(
                  'Protein: ${item['protein']}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFFD4D4D8),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('|', style: TextStyle(color: Color(0xFF52525B))),
                ),
                Text(
                  'Carbs: ${item['carbs']}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFFD4D4D8),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('|', style: TextStyle(color: Color(0xFF52525B))),
                ),
                Text(
                  'Fat: ${item['fat']}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFFD4D4D8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ContainerIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}


