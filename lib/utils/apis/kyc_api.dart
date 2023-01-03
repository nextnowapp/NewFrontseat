import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:nextschool/screens/frontseat/agent_onboarding/submitted_for_verification.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_bank_details/bank_details_page.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_personal_information/onboard_personal_data_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/verify_account.dart';
import 'package:nextschool/utils/apis/api_list.dart';

import '../../controller/kyc_step_model.dart';
import '../../screens/frontseat/nav_bar.dart';
import '../../utils/utils.dart';
import '../model/frontseat_user_detail_model.dart';

// Api ordered as per App flow

class KycApi {
  static final kycStepModelController = getx.Get.put(KycStepModel());
  static Future<String?> registerUser(
      {String? name,
      String? email,
      String? phone,
      String? password,
      String? deviceToken,
      BuildContext? context}) async {
    final body = {
      'company': name,
      'email': email,
      'phonenumber': phone,
      'password': password,
      'firstname': name,
      'device_token': deviceToken
    };
    FormData formData = FormData.fromMap(body);
    try {
      Dio dio = Dio(BaseOptions(
        headers: {'authtoken': FrontSeatApi.apiKey},
        contentType: 'application/json',
      ));
      final response = await dio.post(
        FrontSeatApi.registerUser,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Account created successfully');
        Utils.saveBooleanValue('isLogged', true);
        var id = response.data['user_data']['staffid'];
        Utils.saveStringValue('uid', id);
        return id;
      }
    } on DioError catch (e) {
      log(e.toString());
      Navigator.pop(context!);
      Utils.showToast(
          'This email already exists, try login using email and password');
      return null;
    }
    return null;
  }

  static Future<int> getOtp(String mobile) async {
    log('Api invoked');
    final body = {'mobile_no': mobile};
    FormData formData = FormData.fromMap(body);
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    final response = await dio.post(
      FrontSeatApi.getOtp,
      data: formData,
    );
    log(response.data.toString());
    if (response.statusCode == 200) {
      return response.data['otp'];
    } else {
      return 0;
    }

    //combine data and extraData into one map
  }

  static mobileVerified(Map<String, dynamic> data) async {
    log(data.toString());
    FormData formData = FormData.fromMap(data);
    try {
      Response response;
      Dio dio = Dio(BaseOptions(
        headers: {'authtoken': FrontSeatApi.apiKey},
        // contentType: 'application/json',
      ));
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Phone Number verified successfully');
      } else {
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      log(e.toString());
      return e.toString();
    }

    //combine data and extraData into one map
  }

  static userLogin(
      {String? email, String? password, BuildContext? context}) async {
    Utils.clearAllValue();
    final body = {'email': email, 'password': password, 'remember': false};
    FormData formData = FormData.fromMap(body);
    try {
      Dio dio = Dio(BaseOptions(
        headers: {'authtoken': FrontSeatApi.apiKey},
        contentType: 'application/json',
      ));
      final response = await dio.post(
        FrontSeatApi.loginUser,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Successfully logged in');
        Utils.saveBooleanValue('isLogged', true);
        var id = response.data['user_data']['staffid'];
        Utils.saveStringValue('uid', id);
        await kycStatus(id);
        await AgentStatus(id);
        Navigator.pushAndRemoveUntil(
            context!,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomBar()),
            (Route<dynamic> route) => route is BottomBar);
      }
    } on DioError catch (e) {
      Utils.showToast('Incorrect Email or Password');
      log(e.toString());
      return e.toString();
    }
  }

  static resetPassword(String email, BuildContext context) async {
    log('Api invoked');
    final body = {'email': email};
    FormData formData = FormData.fromMap(body);
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    try {
      final response = await dio.post(
        FrontSeatApi.resetPass,
        data: formData,
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        Utils.showToast(
            'Reset password email link has been sent to your registered email');
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      Utils.showToast('Incorrect Email address');
      log(e.toString());
      return e.toString();
    }

    //combine data and extraData into one map
  }

  static uploadSelfie(String imagePath, var uid, BuildContext context) async {
    FormData formData = FormData.fromMap({
      'onboarding_steps': 1,
      'user_id': uid,
      'profileUpdated': true,
      'profile_image': await MultipartFile.fromFile(imagePath),
    });
    var token = await Utils.getStringValue('token');
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
        onSendProgress: (received, total) {
          if (total != -1) {
            // progress = (received / total * 100).toDouble();
          }
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Image updated successfully');
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const OnboardPersonalInformation()));
        kycStepModelController.selfieUpdated(true);
      } else {
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  static uploadPersonalInformation(Map<String, dynamic> data) async {
    log(data.toString());
    var token = await Utils.getStringValue('token');
    FormData formData = FormData.fromMap(data);
    try {
      Response response;
      Dio dio = Dio(BaseOptions(
       headers: {'Authorization': token},
        // contentType: 'application/json',
      ));
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Details updated successfully');
        kycStepModelController.personalInformationUpdatedValue = true;
      } else {
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      Utils.showToast('Failed to load');
      log(e.toString());
      return e.toString();
    }

    //combine data and extraData into one map
  }

  static uploadGovtId(int uid, String? dlFront, String? dlRear,
      String nidFront, String nidRear, BuildContext context

      // String bankStatement,
      ) async {
         var token = await Utils.getStringValue('token');
    FormData formData = FormData.fromMap({
      'onboarding_steps':4,
      'user_id': uid,
      'govtIdUploaded': true,
      'drivingLicenceFrontImage':
          dlFront == null ? null : await MultipartFile.fromFile(dlFront),
      'drivingLicenceRearImage':
          dlRear == null ? null : await MultipartFile.fromFile(dlRear),
      'nationiIIdFrontImage': await MultipartFile.fromFile(nidFront),
      'nationiIIdRearImage': await MultipartFile.fromFile(nidRear),
      // 'agent_signature': await MultipartFile.fromFile(signature),
      // 'bank_statement': await MultipartFile.fromFile(bankStatement),
    });

    Response response;
    Dio dio = Dio(BaseOptions(
    headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
      );
      if (response.statusCode == 200) {
        kycStepModelController.govtIdUploaded(true);
        Utils.showToast('Documents uploaded successfully');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BankDetails()));
      } else {
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      Utils.showToast('Failed to load');
      return e.toString();
    }
  }

  static uploadBankdetails(
      {required uid,
      required accountType,
      required accountHolderRelation,
      required bankName,
      required branchName,
      required accNumber,
      required accountHolderName,
      required bankStatement,
      branchcode,
      required context}
      // String bankStatement,
      ) async {
         var token = await Utils.getStringValue('token');
    FormData formData = FormData.fromMap({
      'onboarding_steps':5,
      'accountType': accountType,
      'accHolderRelationship': accountHolderRelation,
      'bankName': bankName,
      'bankBranchName': branchName,
      'bankBranchCode': branchcode,
      'bankAccountNumber': accNumber,
      'bankAccountHolderName': accountHolderName,
      'user_id': uid,
      'banking_document': true,
      'bank_statement': await MultipartFile.fromFile(bankStatement),
    });

    Response response;
    Dio dio = Dio(BaseOptions(
       headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
      );
      if (response.statusCode == 200) {
        kycStepModelController.bankDetailsValue = true;
        Utils.showToast('Bank details updated successfully');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const VerificationScreen()));
      } else {
        Navigator.pop(context);
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      Utils.showToast('Failed to load');
      return e.toString();
    }
  }

  static kycStatus(String id) async {
    FormData formData = FormData.fromMap({'agent_id': id});
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(FrontSeatApi.kycStatus, data: formData);
      if (response.statusCode == 200) {
        log(response.data.toString());
        var data = response.data['user_data'];
        // print(data);
        var govtIdUploaded = data['govtIdUploaded'];
        var personalInformationUpdated = data['personalInformationUpdated'];
        var profileUpdated = data['profileUpdated'];
        var bankDetails = data['banking_document'];
        if (bankDetails == 'true') {
          kycStepModelController.bankDetailsValue = true;
          kycStepModelController.allStepsCompletedValue = true;
        }
        if (govtIdUploaded == 'true') {
          kycStepModelController.govtIdUploadedValue = true;
        }
        if (personalInformationUpdated == 'true') {
          kycStepModelController.personalInformationUpdatedValue = true;
        }
        if (profileUpdated == 'true') {
          kycStepModelController.selfieUpdatedValue = true;
        }
        return data;
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError catch (e) {
      log(e.toString());
      debugPrint('Error Encountered : $e');
    }
    return null;
  }

  static Future<UserDetailModel?> getUserDetails(String id) async {
    FormData formData = FormData.fromMap({'agent_id': id});
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(FrontSeatApi.agentData, data: formData);
      if (response.statusCode == 200) {
        var userData = UserDetailModel.fromJson(response.data);
        return userData;
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError catch (e) {
      print(e);
      debugPrint('Error Encountered : $e');
    }
    return null;
  }

  static Future<String?> AgentStatus(String id) async {
    String? status;
    String? contracted;
    var comments;
    FormData formData = FormData.fromMap({'agent_id': id});
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    final KycStepModelController = getx.Get.put(KycStepModel());
    try {
      response = await dio.post(FrontSeatApi.kycStatus, data: formData);
      if (response.statusCode == 200) {
        var data = response.data['user_data'];
        status = data['agent_status'];
        contracted = data['contract_accept'];

        comments = data['agent_status_comments'];
        if (status == 'Rejected') {
          KycStepModelController.allStepsCompletedValue = false;
          KycStepModelController.isEditableValue = true;
          KycStepModelController.commentValue = comments;
          // return comments;
        }
        if (status == 'Incontracting' && contracted == 'Yes') {
          KycStepModelController.contractedValue = true;
        } else if (status == 'Incontracting') {
          KycStepModelController.inContractingValue = true;
        }
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError {
      debugPrint('');
    }
    return status;
  }

  static Future getPDF(int id) async {
    var data = {
      'User_id': id,
    };
    FormData formData = FormData.fromMap(data);
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(FrontSeatApi.getpdf, data: formData);
      if (response.statusCode == 200) {
        var url = response.data['data'];
        log(url);
        return url;
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError catch (e) {
      print(e);
      debugPrint('Error Encountered : $e');
    }
    return null;
  }

  static contractAgreement(String id, BuildContext context) async {
    try {
      var data = {
        'termscondition_accept': 'Yes',
        'contract_accept': 'Yes',
        'staffid': id,
      };
      FormData formData = FormData.fromMap(data);
      Response response;
      Dio dio = Dio(BaseOptions(
        headers: {'authtoken': FrontSeatApi.apiKey},
        contentType: 'application/json',
      ));
      response = await dio.post(FrontSeatApi.acceptContract, data: formData);
      if (response.statusCode == 200) {
        Utils.showToast('Contract accepted Successfully');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SubmittedForVerificationScreen()));
      } else {
        Utils.showToast('Something went wrong');
      }
    } on DioError catch (e) {
      Utils.showToast('Something went wrong');
      log(e.toString());
      return e.toString();
    }

    //combine data and extraData into one map
  }

  static agentSignature(
    String id,
    String signature,
    // String bankStatement,
  ) async {
    FormData formData = FormData.fromMap({
      'staffid': id,
      'agent_signature': await MultipartFile.fromFile(signature),
    });

    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'authtoken': FrontSeatApi.apiKey},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(
        FrontSeatApi.onboardAgent,
        data: formData,
      );
      if (response.statusCode == 200) {
        Utils.showToast('Signature added Successfully');
      } else {
        Utils.showToast('Something went wrong');
      }
    } on DioError catch (e) {
      return e.toString();
    }
  }

  static checkInOut(String type, String date, String? location) async {
    var id = await Utils.getStringValue('uid');
    var data = {
      'staff_id': id,
      'type_check': type,
      'edit_date': date,
      'point_id': 0,
      'location_user': location,
      'send_notify': 0
    };
    FormData formData = FormData.fromMap(data);
    try {
      Response response;
      Dio dio = Dio(BaseOptions(
        headers: {'authtoken': FrontSeatApi.apiKey},
        // contentType: 'application/json',
      ));
      response = await dio.post(
        FrontSeatApi.checkInOut,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Worklog updated successfully');
      } else {
        Utils.showToast('Failed to load');
      }
    } on DioError catch (e) {
      return e.toString();
    }

    //combine data and extraData into one map
  }
}
