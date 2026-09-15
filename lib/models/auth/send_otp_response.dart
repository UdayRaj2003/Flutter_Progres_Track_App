class SendOtpResponse {
  final String message;
  final bool isSent;

  const SendOtpResponse({
    required this.message,
    required this.isSent,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      message: json['message'] as String,
      isSent: json['isSent'] as bool,
    );
  }
}