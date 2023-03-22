import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/screens/frontseat/services/kyc_api.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>((event, emit) {
      KycApi.userLogin(
          emailtext: event.email.toLowerCase(),
          passwordtext: event.password,
          ctx: event.context,
          btnController: event.buttonController);
    });
    // on<ResetPasswordEvent>((event, emit) {
    //   KycApi.resetPassword(event.email, event.context);
    // });
  }
}
