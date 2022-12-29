part of 'upload_govt_id_bloc.dart';

class UploadGovtIdState {
  UploadGovtIdState();
}

class UploadGovtIdInitial extends UploadGovtIdState {
  UploadGovtIdInitial() : super();
}

class UploadIdDetailsState extends UploadGovtIdState {
  final String? selectedIdentityDocument;
  UploadIdDetailsState({this.selectedIdentityDocument}) : super();
}
