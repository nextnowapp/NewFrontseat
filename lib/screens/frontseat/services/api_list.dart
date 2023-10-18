class FrontSeatApi {
//  https://dev.frontseat.group/
  static const String baseUrl = 'https://dev.frontseat.group/';
  static const String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiRnJvbnRTZWF0IEFwcCIsIm5hbWUiOiJmcm9udF9zZWF0X2FwcCIsIkFQSV9USU1FIjoxNjY1MTM2MzM4fQ.-mvmGOKzk6j1dZB75VoISNF6EEn9gHpDEzmRuNb2IvM';
  static const String base = 'https://frontseat.group';
  static const String loginUser = '$base/api/agentLogin';
  static const String registerUser = '$base/api/agentSignup';
  static const String forgotPass = '$base/api/agentForgotPassword';
  static const String resetPass = '$base/api/agentResetPassword';
  static const String getOtp = '$base/api/phoneVerificationRequest';
  static const String getEmail = '$base/api/emailVerificationRequest';
  static const String mobileverified = '$base/api/phoneVerificationSave';
  static const String emailverified = '$base/api/emailVerificationSave';
  static const String onboardAgent = '$base/api/agentUpdate';
  static const String signContract = '$base/api/agentSignContract';
  static const String kycStatus = '$base/api/agentKYC';
  static const String status = '$base/api/agentStatus';
  static const String agentData = '$base/api/agentDetails';
  static const String checkInOut = '$baseUrl/timesheets/api/check_in_out';
  static const String acceptContract = '$base/api/agentAcceptReject';
  static const String getpdf = '$base/api/agentContractPdf';
  static String setToken(String? id, String? token) {
    return base + '/api/' + 'set-fcm-token?id=$id&token=$token';
  }
}
