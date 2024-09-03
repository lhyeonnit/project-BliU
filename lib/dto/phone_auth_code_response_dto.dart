import 'package:BliU/data/phone_auth_code_data.dart';

class PhoneAuthCodeResponseDTO {
  final bool? result;
  final String? message;
  final PhoneAuthCodeData? data;

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
      data: (json['data'] as PhoneAuthCodeData),
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