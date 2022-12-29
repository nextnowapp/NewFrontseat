part of 'upload_bank_details_bloc.dart';

@immutable
abstract class UploadBankDetailsEvent {}

class UploadBankDocumentsEvent extends UploadBankDetailsEvent {
  String accountType;
  String accountHolderRelation;
  String bankName;
  String? branchName;
  String? branchcode;
  String accNumber;
  String accountHolderName;
  String bankStatement;
   BuildContext context;
  UploadBankDocumentsEvent({
    required this.accountType,
    required this.accountHolderRelation,
    required this.bankName,
    required this.accNumber,
    required this.accountHolderName,
    required this.bankStatement,
    required this.context,
     this.branchName,
     this.branchcode,
  });
}
