class PhoneAuthCodeDTO {
  final String? resultCode;
  final String? message;
  final String? msgId;
  final int? successCnt;
  final int? errorCnt;
  final String? msgType;

  PhoneAuthCodeDTO({
    required this.resultCode,
    required this.message,
    required this.msgId,
    required this.successCnt,
    required this.errorCnt,
    required this.msgType,
  });

  // JSON to Object
  factory PhoneAuthCodeDTO.fromJson(Map<String, dynamic> json) {
    return PhoneAuthCodeDTO(
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

class PhoneAuthCodeResponseDTO {
  final bool? result;
  final String? message;
  final PhoneAuthCodeDTO? data;

  PhoneAuthCodeResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory PhoneAuthCodeResponseDTO.fromJson(Map<String, dynamic> json) {
    return PhoneAuthCodeResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as PhoneAuthCodeDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}