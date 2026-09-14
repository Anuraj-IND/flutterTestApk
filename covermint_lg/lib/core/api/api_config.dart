/// Base URL injected via `--dart-define=API_BASE=...`, defaults to prod.
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://multilevelcrm.onrender.com',
  );

  // --- Registration ---
  static const String registerInit = '/api/lg/register/init';
  static const String otpSend = '/api/lg/otp/send';
  static const String otpVerify = '/api/lg/otp/verify';
  static String registerDraft(String draftId) => '/api/lg/register/$draftId';
  static String registerDocs(String draftId) =>
      '/api/lg/register/$draftId/documents';
  static String tosAccept(String draftId) =>
      '/api/lg/register/$draftId/tos-accept';
  static String registerSubmit(String draftId) =>
      '/api/lg/register/$draftId/submit';

  // --- Login + dashboard ---
  static const String loginVerify = '/api/lg/login/verify';
  static const String dashboard = '/api/lg/me/dashboard';

  // --- Sell hub + bottom-nav tabs ---
  static const String catalog = '/api/lg/catalog/insurance';
  static const String policyIntent = '/api/lg/intents/policy';
  static const String leads = '/api/lg/me/leads';
  static const String renewals = '/api/lg/me/renewals';
  static const String performance = '/api/lg/me/performance';

  // --- Utils + TOS ---
  static const String ifscVerify = '/api/utils/ifsc/verify';
  static const String tosLatest = '/api/tos?version=latest';
}
