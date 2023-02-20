class LoginRequest {
  late String email;
  late String password;
  late String imei;
  late String deviceType;

  LoginRequest(
      {required this.email,
      required this.password,
      required this.imei,
      required this.deviceType});
}

class RegisterRequest {
  late String countryMobileCode;
  late String userName;
  late String email;
  late String password;
  late String mobileNumber;
  late String profilePicture;

  RegisterRequest({
    required this.countryMobileCode,
    required this.userName,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.profilePicture,
  });
}
