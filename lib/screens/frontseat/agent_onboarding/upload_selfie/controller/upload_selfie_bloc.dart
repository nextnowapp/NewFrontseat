import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../utils/Utils.dart';
import '../../../services/kyc_api.dart';

part 'upload_selfie_event.dart';
part 'upload_selfie_state.dart';

class UploadSelfieBloc extends Bloc<UploadSelfieEvent, UploadSelfieState> {
  UploadSelfieBloc() : super(UploadSelfieInitial()) {
    on<PickImageEvent>((event, emit) {
      state.imagePath = event.image;
      emit(UploadSelfieState(imagePath: state.imagePath));
    });
    on<UpdateSelfieEvent>((event, emit) async {
      var uid = await Utils.getIntValue('id');
      await KycApi.uploadSelfie(event.image, uid!, event.context);
    });
  }
}
