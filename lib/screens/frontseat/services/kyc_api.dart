import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_bank_details/bank_details_page.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_personal_information/onboard_personal_data_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/verify_account.dart';
import 'package:nextschool/screens/frontseat/services/api_list.dart';
import 'package:nextschool/utils/model/kyc_status_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/utils.dart';
import '../agent_onboarding/upload_signature/agent_details_verification.dart';
import '../model/frontseat_user_detail_model.dart';
import '../nav_bar.dart';

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
        var id = response.data['user_data']['id'];
        Utils.saveStringValue('id', id);
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

  static getOtp() async {
    var token = await Utils.getStringValue('token');
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    final response = await dio.get(
      FrontSeatApi.getOtp,
    );
    if (response.statusCode == 200) {
      log('success');
      KycApi.kycStatus();
    } else {}
    //combine data and extraData into one map
  }

  static getEmail() async {
    log('api called');
    var token = await Utils.getStringValue('token');
    Dio dio = Dio(BaseOptions(headers: Utils.setHeader(token!)));
    final response = await dio.get(
      FrontSeatApi.getEmail,
    );
    if (response.statusCode == 200) {
      Utils.showToast('The OTP has been sent to signup email of the user');
    } else {
      Utils.showToast(
          'Your signup email is invalid, please contact with administrator');
    }
    //combine data and extraData into one map
  }

  static mobileVerified(Map<String, dynamic> data, BuildContext context) async {
    FormData formData = FormData.fromMap(data);
    var token = await Utils.getStringValue('token');
    try {
      Response response;
      Dio dio = Dio(BaseOptions(headers: Utils.setHeader(token!)
          // contentType: 'application/json',
          ));
      response = await dio.post(
        FrontSeatApi.mobileverified,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Phone No. verified successfully');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBar(),
            ));
      } else if (response.statusCode == 404) {
        Utils.showToast(response.statusMessage.toString());
      }
    } on DioError catch (e) {
      log(e.toString());
      Utils.showToast('Invalid OTP');
      return e.toString();
    }

    //combine data and extraData into one map
  }

  static emailVerified(Map<String, dynamic> data, BuildContext context) async {
    FormData formData = FormData.fromMap(data);
    var token = await Utils.getStringValue('token');
    try {
      Response response;
      Dio dio = Dio(BaseOptions(headers: Utils.setHeader(token!)
          // contentType: 'application/json',
          ));
      response = await dio.post(
        FrontSeatApi.emailverified,
        data: formData,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Utils.showToast('Email verified successfully');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomBar()),
            (Route<dynamic> route) => route is BottomBar);
      } else if (response.statusCode == 404) {
        Utils.showToast(response.statusMessage.toString());
      }
    } on DioError catch (e) {
      log(e.toString());
      Utils.showToast('Invalid OTP');

      return e.toString();
    }

    //combine data and extraData into one map
  }

  static userLogin(
      {String? emailtext,
      String? passwordtext,
      BuildContext? ctx,
      RoundedLoadingButtonController? btnController}) async {
    Utils.clearAllValue();
    UserDetailsController controller = getx.Get.put(UserDetailsController());
    int id;
    int roleId;
    String role;
    String fullName;
    String email;
    String mobile;
    String dob;
    String photo;
    int genderId;
    String gender;
    String designation;
    int zoom;
    String is_administrator;
    String user_type;
    String token;
    bool isLogged;
    String schoolUrl;
    var message;
    Dio dio = Dio();
    var data = {
      'email': emailtext,
      'password': passwordtext,
    };
    try {
      final response = await dio.post(
        FrontSeatApi.loginUser,
        data: data,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = response.data;
        var userData = data['data']['user'];
        // getting the required data from the response
        id = userData['id'];
        roleId = userData['role_id'];
        role = userData['role'];
        fullName = userData['fullname'];
        email = userData['email'] ?? '';
        mobile = userData['mobile'] ?? '';
        dob = userData['dob'];
        photo = userData['image'] ?? (userData['photo'] ?? '');
        genderId = userData['genderId'] ?? 1;
        gender = userData['gender'] ?? '';
        designation = userData['designation'] ?? '';
        zoom = userData['zoom'];
        is_administrator = userData['is_administrator'];
        user_type = userData['user_type'];
        token = userData['accessToken'];
        schoolUrl = FrontSeatApi.base;

        //saving data in local
        Utils.saveIntValue('id', id);
        Utils.saveIntValue('roleId', roleId);
        Utils.saveStringValue('rule', role);
        Utils.saveStringValue('fullname', fullName);
        Utils.saveStringValue('email', email);
        Utils.saveStringValue('mobile', mobile);
        Utils.saveStringValue('dob', dob);
        Utils.saveStringValue('image', photo);
        Utils.saveIntValue('genderId', genderId);
        Utils.saveStringValue('gender', gender);
        Utils.saveStringValue('designation', designation);
        Utils.saveIntValue('zoom', zoom);
        Utils.saveStringValue('isAdministrator', is_administrator);
        Utils.saveStringValue('user_type', user_type);
        Utils.saveStringValue('token', token);
        Utils.saveBooleanValue('isLogged', true);
        Utils.saveStringValue('schoolUrl', schoolUrl);

        //intialize the user controller with the required data
        controller.id = id;
        controller.roleId = roleId;
        controller.role = role;
        controller.fullName = fullName;
        controller.email = email;
        controller.mobile = mobile;
        controller.dob = dob;
        controller.photo = photo;
        controller.genderId = genderId;
        controller.gender = gender;
        controller.designation = designation;
        controller.zoom = zoom;
        controller.is_administrator = is_administrator;
        controller.user_type = user_type;
        controller.token = token;
        controller.isLogged = true;
        schoolUrl = FrontSeatApi.base;
        Utils.showToast('Successfully logged in');
        await KycApi.kycStatus();
        await KycApi.AgentStatus();
        Navigator.pushAndRemoveUntil(
            ctx!,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomBar()),
            (Route<dynamic> route) => route is BottomBar);
        btnController!.reset();
      } else if (response.statusCode == 400) {
        Utils.showToast(
            'The email address and/or password information you entered does not match the registration informatiom');
        btnController!.reset();
      } else {
        Utils.showToast(
            'The email address and/or password information you entered does not match the registration informatiom');

        btnController!.reset();
      }
    } on DioError catch (e) {
      Utils.showToast(
          'The email address and/or password information you entered does not match the registration informatiom');

      btnController!.reset();
      log(e.toString());
      return e.toString();
    }
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

  static uploadGovtId(
      int uid,
      String? dlFront,
      String? dlRear,
      String? nidFront,
      String? nidRear,
      BuildContext context,
      UserDetailModel? data

      // String bankStatement,
      ) async {
    var token = await Utils.getStringValue('token');
    FormData formData = FormData.fromMap({
      'onboarding_steps': 4,
      'user_id': uid,
      'govtIdUploaded': true,
      'drivingLicenceFrontImage':
          dlFront == null ? null : await MultipartFile.fromFile(dlFront),
      'drivingLicenceRearImage':
          dlRear == null ? null : await MultipartFile.fromFile(dlRear),
      'nationiIIdFrontImage':
          nidFront == null ? null : await MultipartFile.fromFile(nidFront),
      'nationiIIdRearImage':
          nidRear == null ? null : await MultipartFile.fromFile(nidRear),
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
        if (data == null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BankDetails()));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BankDetails(
                        data: data,
                      )));
        }
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
      'onboarding_steps': 5,
      'accountType': accountType,
      'accHolderRelationship': accountHolderRelation,
      'bankName': bankName,
      'bankBranchName': branchName,
      'bankBranchCode': branchcode,
      'bankAccountNumber': accNumber,
      'bankAccountHolderName': accountHolderName,
      'user_id': uid,
      'banking_document': true,
      'bank_statement': bankStatement == null
          ? null
          : await MultipartFile.fromFile(bankStatement),
    });
    log('api invoked');
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

  static kycStatus() async {
    Response response;
    var token = await Utils.getStringValue('token');
    Dio dio = Dio(BaseOptions(headers: Utils.setHeader(token!)));
    try {
      response = await dio.get(FrontSeatApi.kycStatus);
      if (response.statusCode == 200) {
        print(response.data);
        var userData = KycStatusModel.fromJson(response.data);
        // print(data);
        var govtIdUploaded = userData.data!.agentKYCDetails!.govtIdUploaded;
        var personalInformationUpdated =
            userData.data!.agentKYCDetails!.personalInformationUpdated;
        var profileUpdated = userData.data!.agentKYCDetails!.profileUpdated;
        var bankDetails = userData.data!.agentKYCDetails!.bankingDocument;
        if (bankDetails == true) {
          kycStepModelController.bankDetailsValue = true;
          kycStepModelController.allStepsCompletedValue = true;
        }
        if (govtIdUploaded == true) {
          kycStepModelController.govtIdUploadedValue = true;
        }
        if (personalInformationUpdated == true) {
          kycStepModelController.personalInformationUpdatedValue = true;
        }
        if (profileUpdated == true) {
          kycStepModelController.selfieUpdatedValue = true;
        }
        return userData;
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError catch (e) {
      log(e.toString());
      debugPrint('Error Encountered : $e');
    }
    return null;
  }

  static Future<UserDetailModel?> getUserDetails() async {
    var token = await Utils.getStringValue('token');
    Response response;
    var dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.get(FrontSeatApi.agentData);
      if (response.statusCode == 200) {
        log(response.data.toString());
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

  static Future<String?> AgentStatus() async {
    String? status;
    String? pdfReady;
    var comments;
    var reviewer;
    var token = await Utils.getStringValue('token');
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    final KycStepModelController = getx.Get.put(KycStepModel());
    try {
      response = await dio.get(FrontSeatApi.status);
      if (response.statusCode == 200) {
        log(response.data.toString());
        var data = response.data['data']['AgentStatusDetails'];
        status = data['latest_status'];
        pdfReady = data['final_doc'];
        comments = data['latest_comment'];
        reviewer = data['agent_under'];
        log(pdfReady.toString());
        if (status == 'Rejected') {
          KycStepModelController.allStepsCompletedValue = false;
          KycStepModelController.isEditableValue = true;
          KycStepModelController.commentValue = comments;
          KycStepModelController.reviewerValue = reviewer;
          KycStepModelController.rejectedValue = false;
          // return comments;
        }
        if (status == 'Rejected Outright') {
          KycStepModelController.allStepsCompletedValue = false;
          KycStepModelController.isEditableValue = true;
          KycStepModelController.rejectedValue = true;
          KycStepModelController.commentValue = comments;
          KycStepModelController.reviewerValue = reviewer;
          KycStepModelController.pdfReadyValue = false;
          KycStepModelController.inContractingValue = false;
          KycStepModelController.contractedValue = false;
          // return comments;
        }
        if (status == 'Awaiting Company Signature' && pdfReady != null ||
            pdfReady.toString().length > 5) {
          KycStepModelController.rejectedValue = false;
          KycStepModelController.pdfReadyValue = true;
          KycStepModelController.inContractingValue = true;
          KycStepModelController.contractedValue = true;
        } else if (status == 'Awaiting Company Signature') {
          KycStepModelController.rejectedValue = false;
          KycStepModelController.contractedValue = true;
          KycStepModelController.inContractingValue = true;
          KycStepModelController.pdfReadyValue = false;
        }
        if (status == 'Ready to Sign Contract') {
          KycStepModelController.inContractingValue = true;
          KycStepModelController.rejectedValue = false;
          KycStepModelController.contractedValue = false;
        }
        if (status == 'Active') {
          KycStepModelController.rejectedValue = false;
          KycStepModelController.pdfReadyValue = false;
          KycStepModelController.inContractingValue = false;
          KycStepModelController.contractedValue = false;
          KycStepModelController.activeValue = true;
        }
      } else {
        debugPrint('Error Encountered : ${response.data}');
      }
    } on DioError {
      debugPrint('');
    }
    return status;
  }

  static Future getPDF() async {
    var token = await Utils.getStringValue('token');
    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.get(FrontSeatApi.getpdf);
      if (response.statusCode == 200) {
        log(response.data.toString());
        var url = response.data['data']['final_doc'];
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

  static contractAgreement(String value, BuildContext context) async {
    try {
      var data = {
        'accept_reject': value,
      };
      var token = await Utils.getStringValue('token');
      FormData formData = FormData.fromMap(data);
      Response response;
      Dio dio = Dio(BaseOptions(
        headers: {'Authorization': token},
        contentType: 'application/json',
      ));
      response = await dio.post(FrontSeatApi.acceptContract, data: formData);
      if (response.statusCode == 200) {
        Utils.showToast('Contract submitted successfully');
        if (value == 'accept') {}
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => const BottomBar(
                      index: 1,
                    ))));
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
      String location, String signature, String date, BuildContext context
      // String bankStatement,
      ) async {
    var token = await Utils.getStringValue('token');
    FormData formData = FormData.fromMap({
      'agent_signature_location': location,
      'agent_signature_date': date,
      'agent_signature_file': await MultipartFile.fromFile(signature),
    });

    Response response;
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    try {
      response = await dio.post(
        FrontSeatApi.signContract,
        data: formData,
      );
      if (response.statusCode == 200) {
        var data = await getUserDetails();
        Utils.showToast('Details added Successfully');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgentDetailsVerificationScreen(
                      data: data!.data!.agentDetails!,
                    )));
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
