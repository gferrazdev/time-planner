abstract interface class ILoginDataSource {
  Future<void> requestOtp(String identifier);
  Future<String> validateOtp(String identifier, String otp); 
}