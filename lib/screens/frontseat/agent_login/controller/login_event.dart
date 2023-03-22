part of 'login_bloc.dart';

class LoginEvent {}

class ShowPassEvent extends LoginEvent {}

class LoginUserEvent extends LoginEvent {
  String email;
  String password;
  BuildContext context;
  RoundedLoadingButtonController buttonController;
  LoginUserEvent(
      {required this.email, required this.password, required this.context,required this.buttonController});
}

class ResetPasswordEvent extends LoginEvent {
  String email;
  BuildContext context;
  ResetPasswordEvent({required this.email, required this.context});
}
