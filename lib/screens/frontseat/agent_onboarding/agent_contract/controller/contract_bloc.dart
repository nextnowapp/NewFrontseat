import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import '../../../../../utils/apis/kyc_api.dart';
part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc() : super(ContractInitial()) {
    on<AcceptAgreementEvent>((event, emit) async {
      var id = await Utils.getStringValue('uid');
      await KycApi.contractAgreement(id!, event.context);
    });
    on<AcceptFirstCheckEvent>((event, emit) {
      emit(ContractState(
          aceeptFirstAgreement: !state.aceeptFirstAgreement,
          aceeptSecondAgreement: state.aceeptSecondAgreement,
          aceeptThirdAgreement: state.aceeptThirdAgreement));
    });
    on<AcceptSecondCheckEvent>((event, emit) {
      emit(ContractState(
          aceeptFirstAgreement: state.aceeptFirstAgreement,
          aceeptSecondAgreement:!state.aceeptSecondAgreement,
          aceeptThirdAgreement: state.aceeptThirdAgreement));
    });
    on<AcceptThirdCheckEvent>((event, emit) {
      emit(ContractState(
          aceeptFirstAgreement: state.aceeptFirstAgreement,
          aceeptSecondAgreement:state.aceeptSecondAgreement,
          aceeptThirdAgreement: !state.aceeptThirdAgreement));
    });
     on<SignatureEvent>((event, emit) async{
    var id = await Utils.getStringValue('uid');

                    final Uint8List? data =
                        await event.controller.toPngBytes();
                    final tempDir = await getTemporaryDirectory();
                    File file =
                        await File('${tempDir.path}/image.png').create();
                    file.writeAsBytesSync(data!.buffer
                        .asUint8List(data.offsetInBytes, data.lengthInBytes));
                    // final bytes = await image!.readAsBytes();
                    // var value = base64.encode(bytes);
                     await KycApi.agentSignature(
                        id!, '${tempDir.path}/image.png');
    });
  }
}
