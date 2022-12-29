part of 'contract_bloc.dart';

class ContractState {
  final bool aceeptFirstAgreement;
  final bool aceeptSecondAgreement;
  final bool aceeptThirdAgreement;
   ContractState({required this.aceeptFirstAgreement, required this.aceeptSecondAgreement,required this.aceeptThirdAgreement,});
}


class ContractInitial extends ContractState {
   ContractInitial() : super(aceeptFirstAgreement: false, aceeptSecondAgreement: false ,aceeptThirdAgreement: false);
}
