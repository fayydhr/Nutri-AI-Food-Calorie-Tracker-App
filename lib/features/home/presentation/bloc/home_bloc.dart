import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeLoadDashboard>(_onLoadDashboard);
    on<HomeChangeTab>(_onChangeTab);
  }

  Future<void> _onLoadDashboard(
    HomeLoadDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void _onChangeTab(
    HomeChangeTab event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tabIndex));
  }
}
