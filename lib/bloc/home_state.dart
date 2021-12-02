import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HomeLoadedState extends HomeState {
  final List<dynamic> home;

  HomeLoadedState({@required this.home});

  @override
  // TODO: implement props
  List<Object> get props => [home];
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
