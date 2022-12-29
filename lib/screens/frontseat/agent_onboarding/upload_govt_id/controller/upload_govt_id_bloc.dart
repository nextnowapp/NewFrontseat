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
        'drivingLicenseId': event.drivingLicense,
        'id_number': event.idDocument,
        'staffid': id,
      };
      await KycApi.uploadPersonalInformation(data);
    });
    on<UploadGovtIdDocumentsEvent>((event, emit) async {
      int? id = await Utils.getIntValue('id');
      ProgressDialog pd = ProgressDialog(context: event.context);
      pd.show(max: 100, msg: 'Uploading Data');

      await KycApi.uploadGovtId(id!, event.dlFront, event.dlRear, event.idFront,
          event.idRear, event.context);
    });
  }
}
