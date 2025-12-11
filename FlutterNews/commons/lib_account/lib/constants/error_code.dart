class ErrorCode {
  // The agreements are not accepted.
  static const int ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED = 1005300001;
  // Invalid input parameter value.
  static const int ERROR_CODE_INVALID_PARAM = 1001502003;
  // The app does not have the required scopes or permissions.
  static const int ERROR_CODE_NOT_SCOPE = 1001502014;
  // No HUAWEI ID has been signed in.
  static const int ERROR_CODE_LOGIN_OUT = 1001502001;
  // This HUAWEI ID does not support one-tap sign-in as it is a child account or not registered in the Chinese mainland.
  static const int ERROR_CODE_NOT_SUPPORTED = 1001500003;
  // The operation for obtaining the shipping address is canceled.
  static const int SHIPPING_ADDRESS_USER_CANCELED = 1008100006;
  // Authorization revoking is performed.
  static const int AUTHENTICATION_USER_CANCELED = 1001502012;
  // The operation for obtaining the invoice title is canceled.
  static const int INVOICE_ASSISTANT_USER_CANCELED = 1010060001;
  // A network exception occurred in the API for obtaining the shipping address.
  static const int SHIPPING_ADDRESS_NETWORK_ERROR = 1008100002;
  // A network exception occurs in the authorization API.
  static const int AUTHENTICATION_NETWORK_ERROR = 1001502005;
  // A network exception occurred in the API for obtaining the invoice title.
  static const int INVOICE_ASSISTANT_NETWORK_ERROR = 1010060005;
  // Internal error.
  static const int ERROR_CODE_INTERNAL_ERROR = 1001502009;
  // Authorization revoking is performed.
  static const int ERROR_CODE_USER_CANCEL = 1001502012;
  // System service exception.
  static const int ERROR_CODE_SYSTEM_SERVICE = 12300001;
  // Repeated request.
  static const int ERROR_CODE_REQUEST_REFUSE = 1001500002;
}
