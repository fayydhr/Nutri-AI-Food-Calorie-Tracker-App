import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashCompleted extends SplashState {
  final bool isFirstTime;

  const SplashCompleted({this.isFirstTime = true});

  @override
  List<Object?> get props => [isFirstTime];
}
