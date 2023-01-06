part of 'upload_govt_id_bloc.dart';

@immutable
abstract class UploadGovtIdEvent {}

class UploadGovtIdDetailsEvent extends UploadGovtIdEvent {
  String? idDocument;
  String documentType;
  String? drivingLicense;
  String? country;
  String? asylum;
  String? passport;
  UploadGovtIdDetailsEvent({ this.idDocument,required this.documentType ,this.drivingLicense,this.country,this.asylum,this.passport});
}

class UploadGovtIdDocumentsEvent extends UploadGovtIdEvent {
  String idFront;
  String idRear;
  String? dlFront;
  String? dlRear;
  BuildContext context;
  UploadGovtIdDocumentsEvent(
      {required this.idFront,
      required this.idRear,
      required this.context,
      this.dlFront,
      this.dlRear});
}
