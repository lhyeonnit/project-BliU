class PhoneAuthCodeData {
  final String? resultCode;
  final String? message;
  final String? msgId;
  final int? successCnt;
  final int? errorCnt;
  final String? msgType;

  PhoneAuthCodeData({
    required this.resultCode,
    required this.message,
    required this.msgId,
    required this.successCnt,
    required this.errorCnt,
    required this.msgType,
  });

  // JSON to Object
  factory PhoneAuthCodeData.fromJson(Map<String, dynamic> json) {
    return PhoneAuthCodeData(
      resultCode: json['result_code'],
      message: json['message'],
      msgId: json['msg_id'],
      successCnt: json['success_cnt'],
      errorCnt: json['error_cnt'],
      msgType: json['msg_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'result_code': resultCode,
      'message': message,
      'msg_id': msgId,
      'success_cnt': successCnt,
      'error_cnt': errorCnt,
      'msg_type': msgType,
    };
  }
}