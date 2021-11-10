part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoaded extends LoginState {
  final Login? loginResponse;
  

  LoginLoaded({required this.loginResponse});

}
