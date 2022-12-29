import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/submitted_for_verification.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_govt_id/govt_id_details.dart';

import '../../../../../controller/kyc_step_model.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/apis/kyc_api.dart';

part 'upload_personal_information_event.dart';
part 'upload_personal_information_state.dart';

class UploadPersonalInformationBloc extends Bloc<UploadPersonalInformationEvent,
    UploadPersonalInformationState> {
  UploadPersonalInformationBloc() : super(UploadPersonalInformationInitial()) {
    on<CopyAddressEvent>((event, emit) {
      emit(UploadPersonalInformationState(sameAddress: !state.sameAddress));
    });
    on<UploadPersonalDataEvent>((event, emit) async {
      final kycStepModelController = Get.put(KycStepModel());
      var id = await Utils.getIntValue('id');
      try {
        var data = {
          'user_id': id,
          'title': event.title,
          'firstName': event.firstName,
          'middleName': event.middleName,
          'lastName': event.lastName,
          'passportNumber': event.passportNumber,
          'phonenumber': event.phoneNumber,
          'email': event.email,
          'gender': event.gender,
          'maritalStatus': event.maritalStatus,
          'equityGroup': event.equityGroup,
          'dob': event.dob,
          'incomeTax': event.tax,
          'disability': event.disability,
          'Nationality': event.nationality,
          'Country_of_Birth': event.countryofBirth,
          'residentialAddress': event.residentialAddress,
          'residentialCity': event.residentialCity,
          'residentialprovince': event.residentialProvince,
          'residentialPostalCode': event.residentialPostalCode,
          'postalAddress': event.postalAddress,
          'postalprovince': event.postalProvince,
          'postalCity': event.postalCity,
          'postalPostalCode': event.postalPostalCode,
          'personalInformationUpdated': true,
          'emergencyContactRelation': event.emergencyContactRelation,
          'emergencyContactFullName': event.emergencyContactFullName,
          'emergencyContactNumber': event.emergencyContactNumber,
          'emergencyAlternativeNumber': event.emergencyAlternativeContactNumber,
          'workLocation': event.workLocation,
          'workCity': event.workCity,
          'workProvince': event.workProvince
        };
        await KycApi.uploadPersonalInformation(data);
        if (kycStepModelController.isEditableValue) {
          kycStepModelController.isEditableValue = false;
          kycStepModelController.allStepsCompletedValue = true;
          Navigator.pushReplacement(
              event.context,
              MaterialPageRoute(
                  builder: (context) =>
                      const SubmittedForVerificationScreen()));
        } else {
          Navigator.pushReplacement(event.context,
              MaterialPageRoute(builder: (context) => const GovtIdDetails()));
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
