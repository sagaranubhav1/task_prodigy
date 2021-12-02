import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:softprodigy_task/bloc/home_event.dart';
import 'package:softprodigy_task/bloc/home_state.dart';
import 'package:softprodigy_task/data/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeRepository repository;

  HomeBloc({@required this.repository}) : super(null);

  @override
  // TODO: implement initialState
  HomeState get initialState => HomeInitialState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is FetchHomeEvent) {
      yield HomeLoadingState();
      try {
        List<dynamic> images = await repository.getImages();
        yield HomeLoadedState(home: images);
      } catch (e) {
        yield HomeErrorState(message: e.toString());
      }
    }
  }
}
