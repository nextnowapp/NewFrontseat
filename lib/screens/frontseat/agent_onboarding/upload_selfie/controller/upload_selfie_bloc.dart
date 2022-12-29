import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../../utils/Utils.dart';
import '../../../../../utils/apis/kyc_api.dart';
part 'upload_selfie_event.dart';
part 'upload_selfie_state.dart';

class UploadSelfieBloc extends Bloc<UploadSelfieEvent, UploadSelfieState> {
  UploadSelfieBloc() : super(UploadSelfieInitial()) {
    on<PickImageEvent>((event, emit) {
      state.imagePath = event.image;
    });
    on<UpdateSelfieEvent>((event, emit) async {
      var uid = await Utils.getIntValue('id');
      await KycApi.uploadSelfie(event.image, uid!, event.context);
    });
  }
}
