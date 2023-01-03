import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../../utils/apis/kyc_api.dart';


part 'upload_bank_details_event.dart';
part 'upload_bank_details_state.dart';

class UploadBankDetailsBloc
    extends Bloc<UploadBankDetailsEvent, UploadBankDetailsState> {
  UploadBankDetailsBloc() : super(UploadBankDetailsInitial()) {
    on<UploadBankDocumentsEvent>((event, emit) async {
      int? id = await Utils.getIntValue('id');
      await KycApi.uploadBankdetails(
          accountType: event.accountType,
          accountHolderRelation: event.accountHolderRelation,
          bankName: event.bankName,
          branchName: event.branchName,
          branchcode: event.branchcode,
          accNumber: event.accNumber,
          accountHolderName: event.accountHolderName,
          uid: id,
          bankStatement: event.bankStatement,
          context: event.context);
    });
  }
}
