import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/events.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/states.dart';

class homePageTabBarBloc extends Bloc<tabBarEvents, tabBarStates> {
  homePageTabBarBloc() : super(activeState(index: 0)) {
    on<activeTab>((event, emit) {
      emit(activeState(index: event.index));
    });
  }
}
