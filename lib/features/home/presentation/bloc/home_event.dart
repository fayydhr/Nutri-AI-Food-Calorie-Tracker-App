import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadDashboard extends HomeEvent {}

class HomeChangeTab extends HomeEvent {
  final int tabIndex;

  const HomeChangeTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
