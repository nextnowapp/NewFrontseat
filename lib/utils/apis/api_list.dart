class FrontSeatApi {
  static const String baseUrl = 'https://nextone.co.za/frontseat_crm';
  static const String apiKey = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiRnJvbnRTZWF0IEFwcCIsIm5hbWUiOiJmcm9udF9zZWF0X2FwcCIsIkFQSV9USU1FIjoxNjY1MTM2MzM4fQ.-mvmGOKzk6j1dZB75VoISNF6EEn9gHpDEzmRuNb2IvM';
   static const String base = 'https://frontseat.nextnow.group';
  static const String loginUser = '$base/api/agentLogin';
  static const String registerUser = '$base/api/agentSignup';
  static const String resetPass = '$baseUrl/api/Applogin/resetpassword';
  static const String getOtp = '$baseUrl/api/Applogin/sendotp';
  static const String onboardAgent = '$base/api/agentUpdate';
  static const String kycStatus = '$baseUrl/api/Applogin/agentUploadStatus';
  static const String agentData = '$baseUrl/api/Applogin/agentData/';
  static const String checkInOut = '$baseUrl/timesheets/api/check_in_out';
  static const String acceptContract = '$baseUrl/api/Applogin/agentContractAccept';
   static const String getpdf = '$baseUrl/api/Applogin/agentContractPdf';
}
