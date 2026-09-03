import 'package:flutter/foundation.dart';

class FoodLogItem {
  final String id;
  final String foodName;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime timestamp;

  FoodLogItem({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
  });
}

class NutritionLogService extends ChangeNotifier {
  static final NutritionLogService _instance = NutritionLogService._internal();
  factory NutritionLogService() => _instance;
  NutritionLogService._internal();

  int _consumedCalories = 920;
  final int _targetCalories = 2000;

  int _consumedProtein = 65;
  int _consumedCarbs = 110;
  int _consumedFat = 38;

  final List<FoodLogItem> _loggedItems = [
    FoodLogItem(
      id: '1',
      foodName: 'Oatmeal & Berries',
      calories: 380,
      protein: 15,
      carbs: 55,
      fat: 10,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    FoodLogItem(
      id: '2',
      foodName: 'Grilled Chicken Salad',
      calories: 540,
      protein: 50,
      carbs: 55,
      fat: 28,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  int get consumedCalories => _consumedCalories;
  int get targetCalories => _targetCalories;
  int get consumedProtein => _consumedProtein;
  int get consumedCarbs => _consumedCarbs;
  int get consumedFat => _consumedFat;

  List<FoodLogItem> get loggedItems => List.unmodifiable(_loggedItems);

  void addScannedFood({
    required String foodName,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) {
    final newItem = FoodLogItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: foodName,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      timestamp: DateTime.now(),
    );

    _loggedItems.insert(0, newItem);
    _consumedCalories += calories;
    _consumedProtein += protein;
    _consumedCarbs += carbs;
    _consumedFat += fat;

    notifyListeners();
  }
}
