class ApiConstants {
  // Live Render Production Backend URL
  static String baseUrl = 'https://bidhaul-backend.onrender.com';

  // Auth endpoints
  static const String signup = '/api/v1/auth/signup';
  static const String login = '/api/v1/auth/login';
  static const String adminLogin = '/api/v1/auth/admin-login';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String me = '/api/v1/auth/me';

  // Company endpoints
  static const String companyProfile = '/api/v1/company/profile';
  static const String companyKycSubmit = '/api/v1/company/kyc/submit';

  // Transporter endpoints
  static const String transporterProfile = '/api/v1/transporter/profile';
  static const String transporterKycSubmit = '/api/v1/transporter/kyc/submit';

  // Tender endpoints
  static const String tenders = '/api/v1/tenders';
  static const String myTenders = '/api/v1/tenders/my';
  static const String liveTenders = '/api/v1/tenders/live';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
