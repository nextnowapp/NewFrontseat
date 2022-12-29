part of 'upload_personal_information_bloc.dart';

@immutable
abstract class UploadPersonalInformationEvent {}
class CopyAddressEvent extends UploadPersonalInformationEvent{}
class UploadPersonalDataEvent extends UploadPersonalInformationEvent {
  BuildContext context;
  String title;
  String firstName;
  String? middleName;
  String lastName;
  String phoneNumber;
  String email;
  String? passportNumber;
  String gender;
  String maritalStatus;
  String workCity;
  String workProvince;
  String workLocation;
  String equityGroup;
  String disability;
  String nationality;
  String countryofBirth;
  String dob;
  String? tax;
  //Residential address
  String residentialAddress;
  String residentialProvince;
  String residentialCity;
  String residentialPostalCode;
  //Postal address
  String postalAddress;
  String postalProvince;
  String postalCity;
  String postalPostalCode;
  String emergencyContactRelation;
  String emergencyContactFullName;
  String emergencyContactNumber;
  String emergencyAlternativeContactNumber;
  UploadPersonalDataEvent(
      {required this.context,
      required this.title,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.email,
      required this.gender,
      required this.maritalStatus,
      required this.equityGroup,
      required this.disability,
      required this.nationality,
      required this.countryofBirth,
      required this.dob,
      required this.workLocation,
      required this.workCity,
      required this.workProvince,
      required this.residentialAddress,
      required this.residentialCity,
      required this.residentialProvince,
      required this.residentialPostalCode,
      required this.postalAddress,
      required this.postalCity,
      required this.postalProvince,
      required this.postalPostalCode,
      required this.emergencyContactRelation,
      required this.emergencyContactFullName,
      required this.emergencyContactNumber,
      required this.emergencyAlternativeContactNumber,
      this.middleName,
      this.tax,
      this.passportNumber});
}
class ResubmitPersonalDataEvent extends UploadPersonalInformationEvent {
  BuildContext context;
  String title;
  String firstName;
  String? middleName;
  String lastName;
  String phoneNumber;
  String email;
  String gender;
  String maritalStatus;
  String equityGroup;
  String disability;
  String nationality;
  String countryofBirth;
  String dob;
  String? tax;
  //Residential address
  String residentialAddress;
  String residentialProvince;
  String residentialCity;
  String residentialPostalCode;
  //Postal address
  String postalAddress;
  String postalProvince;
  String postalCity;
  String postalPostalCode;
  String emergencyContactRelation;
  String emergencyContactFullName;
  String emergencyContactNumber;
  String emergencyAlternativeContactNumber;
  ResubmitPersonalDataEvent(
      {required this.context,
      required this.title,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.email,
      required this.gender,
      required this.maritalStatus,
      required this.equityGroup,
      required this.disability,
      required this.nationality,
      required this.countryofBirth,
      required this.dob,
      required this.residentialAddress,
      required this.residentialCity,
      required this.residentialProvince,
      required this.residentialPostalCode,
      required this.postalAddress,
      required this.postalCity,
      required this.postalProvince,
      required this.postalPostalCode,
      required this.emergencyContactRelation,
      required this.emergencyContactFullName,
      required this.emergencyContactNumber,
      required this.emergencyAlternativeContactNumber,
      this.middleName,
      this.tax});
}
