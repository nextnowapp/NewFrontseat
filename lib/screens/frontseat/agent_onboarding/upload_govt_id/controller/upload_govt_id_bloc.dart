import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../../utils/Utils.dart';
import '../../../../../utils/apis/kyc_api.dart';
part 'upload_govt_id_event.dart';
part 'upload_govt_id_state.dart';

class UploadGovtIdBloc extends Bloc<UploadGovtIdEvent, UploadGovtIdState> {
  UploadGovtIdBloc() : super(UploadGovtIdInitial()) {
    on<UploadGovtIdDetailsEvent>((event, emit) async {
      int? id = await Utils.getIntValue('id');
      var data = {
        'onboarding_steps':3,
        'drivingLicenseId': event.drivingLicense,
        'id_number': event.idDocument,
        'user_id': id,
      };
      await KycApi.uploadPersonalInformation(data);
    });
    on<UploadGovtIdDocumentsEvent>((event, emit) async {
      int? id = await Utils.getIntValue('id');

      await KycApi.uploadGovtId(id!, event.dlFront, event.dlRear, event.idFront,
          event.idRear, event.context);
    });
  }
}
