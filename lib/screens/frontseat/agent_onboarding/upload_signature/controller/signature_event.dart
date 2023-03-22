part of 'signature_bloc.dart';

class SignatureEvent {}

class ConfirmDateEvent extends SignatureEvent {}

class SubmitDataEvent extends SignatureEvent {
  SignatureController controller;
  String location;
  String date;
  BuildContext context;
  SubmitDataEvent({required this.controller,required this.location,required this.date,required this.context});
}
