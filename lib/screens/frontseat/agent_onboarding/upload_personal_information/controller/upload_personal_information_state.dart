part of 'upload_personal_information_bloc.dart';

class UploadPersonalInformationState {
  bool sameAddress;
  UploadPersonalInformationState({required this.sameAddress});
}

class UploadPersonalInformationInitial extends UploadPersonalInformationState {
  UploadPersonalInformationInitial() : super(sameAddress: false);
}
