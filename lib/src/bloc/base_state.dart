import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();
}

class UnInitiatedState extends BaseState {
  @override
  List<Object> get props => [];
}

class LoadingState extends BaseState {
  @override
  List<Object> get props => [];
}

class DataState<T extends Object> extends BaseState {
  final T data;

  DataState(this.data);

  @override
  List<Object> get props => [this.data];
}

class ErrorState extends BaseState {
  final String errorMessage;
  final int errorCode;

  ErrorState({this.errorMessage = "", this.errorCode = 0});

  @override
  List<Object> get props => [this.errorMessage, this.errorCode];
}
