import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final int selectedTab;
  final int caloriesTarget;
  final int caloriesCurrent;
  final double waterLiters;
  final double waterTarget;
  final List<String> todayMeals;

  const HomeState({
    this.isLoading = false,
    this.selectedTab = 0,
    this.caloriesTarget = 2200,
    this.caloriesCurrent = 1450,
    this.waterLiters = 1.8,
    this.waterTarget = 2.5,
    this.todayMeals = const [
      'Avocado Toast & Boiled Eggs',
      'Grilled Chicken Quinoa Bowl',
      'Greek Yogurt with Berries',
    ],
  });

  HomeState copyWith({
    bool? isLoading,
    int? selectedTab,
    int? caloriesTarget,
    int? caloriesCurrent,
    double? waterLiters,
    double? waterTarget,
    List<String>? todayMeals,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      caloriesCurrent: caloriesCurrent ?? this.caloriesCurrent,
      waterLiters: waterLiters ?? this.waterLiters,
      waterTarget: waterTarget ?? this.waterTarget,
      todayMeals: todayMeals ?? this.todayMeals,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedTab,
        caloriesTarget,
        caloriesCurrent,
        waterLiters,
        waterTarget,
        todayMeals,
      ];
}
