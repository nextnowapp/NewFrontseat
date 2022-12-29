part of 'upload_govt_id_bloc.dart';

@immutable
abstract class UploadGovtIdEvent {}

class UploadGovtIdDetailsEvent extends UploadGovtIdEvent {
  String idDocument;
  String? drivingLicense;
  UploadGovtIdDetailsEvent({required this.idDocument, this.drivingLicense});
}

class UploadGovtIdDocumentsEvent extends UploadGovtIdEvent {
  String idFront;
  String idRear;
  String? dlFront;
  String? dlRear;
  BuildContext context;
  UploadGovtIdDocumentsEvent(
      {required this.idFront, required this.idRear,required this.context, this.dlFront, this.dlRear});
}
