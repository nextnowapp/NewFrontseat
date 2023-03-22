part of 'signature_bloc.dart';

class SignatureState {
  final bool confirmDate;
  SignatureState({required this.confirmDate});
}

class SignatureInitial extends SignatureState {
  SignatureInitial() : super(confirmDate: false);
}
