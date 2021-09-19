import 'package:test_project/src/bloc/base_event.dart';

class LoginEvent extends BaseEvent {
  final String strEmail, strPassword;

  LoginEvent(this.strEmail, this.strPassword);

  @override
  List<Object> get props => [this.strEmail, this.strPassword];
}

class RegisterEvent extends BaseEvent {
  final String strName, strEmail, strPassword;

  RegisterEvent(this.strName, this.strEmail, this.strPassword);

  @override
  List<Object> get props => [this.strName, this.strEmail, this.strPassword];
}
