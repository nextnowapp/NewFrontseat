import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../services/kyc_api.dart';

part 'signature_event.dart';
part 'signature_state.dart';

class SignatureBloc extends Bloc<SignatureEvent, SignatureState> {
  SignatureBloc() : super(SignatureInitial()) {
    on<ConfirmDateEvent>((event, emit) {
      emit(SignatureState(confirmDate: !state.confirmDate));
    });
    on<SubmitDataEvent>((event, emit) async {
      final Uint8List? data = await event.controller.toPngBytes();
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(
          data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      // final bytes = await image!.readAsBytes();
      // var value = base64.encode(bytes);
      await KycApi.agentSignature(event.location, '${tempDir.path}/image.png',
          event.date, event.context);
    });
  }
}
