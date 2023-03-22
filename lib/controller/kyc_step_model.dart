import 'package:get/get.dart';
class KycStepModel extends GetxController {
  final Rx<bool> selfieUpdated = false.obs;
  final Rx<bool> personalInformationUpdated = false.obs;
  final Rx<bool> govtIdUploaded = false.obs;
  final Rx<bool> bankDetails = false.obs;
  // final Rx<bool> completedVideoKYC = false.obs;
  final Rx<bool> allStepsCompleted = false.obs;
  final Rx<bool> isEditable = false.obs;
  final Rx<bool> rejected = false.obs;
  final Rx<String> comment = "".obs;
  final Rx<String> reviewer = "".obs;
  final Rx<bool> inContracting = false.obs;
   final Rx<bool> contracted = false.obs;
   final Rx<bool> pdfReady = false.obs;
final Rx<bool> active = false.obs;

  //define getter and setter
  bool get selfieUpdatedValue => selfieUpdated.value;
  bool get personalInformationUpdatedValue => personalInformationUpdated.value;
  bool get govtIdUploadedValue => govtIdUploaded.value;
   bool get bankDetailsValue => bankDetails.value;
  // bool get completedVideoKYCValue => completedVideoKYC.value;
  bool get allStepsCompletedValue => allStepsCompleted.value;
  bool get isEditableValue => isEditable.value;
  bool get rejectedValue => rejected.value;
  bool get inContractingValue => inContracting.value;
  bool get contractedValue => contracted.value;
   bool get activeValue => active.value;
   bool get pdfReadyValue => pdfReady.value;
  String get commentValue => comment.value;
  String get reviewerValue => reviewer.value;

  set selfieUpdatedValue(bool value) {
    selfieUpdated.value = value;
  }

  set personalInformationUpdatedValue(bool value) {
    personalInformationUpdated.value = value;
  }

  set govtIdUploadedValue(bool value) {
    govtIdUploaded.value = value;
  }

  set bankDetailsValue(bool value) {
    bankDetails.value = value;
  }

  set allStepsCompletedValue(bool value) {
    allStepsCompleted.value = value;
  }

  set isEditableValue(bool value) {
    isEditable.value = value;
  }
  set rejectedValue(bool value) {
    rejected.value = value;
  }
  set commentValue(String value) {
    comment.value = value;
  }
  set reviewerValue(String value) {
    reviewer.value = value;
  }
    set inContractingValue(bool value) {
    inContracting.value = value;
  }
   set contractedValue(bool value) {
    contracted.value = value;
  }
   set activeValue(bool value) {
    active.value = value;
  }
  set pdfReadyValue(bool value) {
    pdfReady.value = value;
  }
}
