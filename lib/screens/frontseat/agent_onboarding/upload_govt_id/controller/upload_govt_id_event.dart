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
  UserDetailModel? data;
  UploadGovtIdDetailsEvent({ this.idDocument,required this.documentType ,this.drivingLicense,this.country,this.asylum,this.passport,this.data});
}

class UploadGovtIdDocumentsEvent extends UploadGovtIdEvent {
  String? idFront;
  String? idRear;
  String? dlFront;
  String? dlRear;
  UserDetailModel? data;
  BuildContext context;
  UploadGovtIdDocumentsEvent(
      { this.idFront,
       this.idRear,
      required this.context,
      this.dlFront,
      this.data,
      this.dlRear});
}
