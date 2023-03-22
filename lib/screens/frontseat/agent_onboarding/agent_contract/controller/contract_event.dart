part of 'contract_bloc.dart';

class ContractEvent {}

class AcceptAgreementEvent extends ContractEvent {
  BuildContext context;
  String value;
  AcceptAgreementEvent({required this.context,required this.value});
}

class AcceptFirstCheckEvent extends ContractEvent {}

class AcceptSecondCheckEvent extends ContractEvent {}

class AcceptThirdCheckEvent extends ContractEvent {}

// class SignatureEvent extends ContractEvent {
//   SignatureController controller;
//   SignatureEvent({required this.controller});
// }
