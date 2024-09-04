import 'package:BliU/data/member_info_data.dart';

class MemberInfoResponseDTO {
  final bool? result;
  final String? message;
  MemberInfoData? data;

  MemberInfoResponseDTO({
    required this.result,
    required this.message,
    this.data
  });

  // JSON to Object
  factory MemberInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return MemberInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: MemberInfoData.fromJson(json['data']),
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