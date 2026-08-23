import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool isCompleted;

  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = 3,
    this.isCompleted = false,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, isCompleted];
}
