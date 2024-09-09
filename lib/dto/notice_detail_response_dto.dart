import 'package:BliU/data/notice_data.dart';

class NoticeDetailResponseDTO {
  final bool? result;
  final String? message;
  final NoticeData? data;

  NoticeDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory NoticeDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return NoticeDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: NoticeData.fromJson(json['data']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson()
    };
  }
}