import 'package:BliU/data/notice_data.dart';

class NoticeListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<NoticeData>? list;

  NoticeListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory NoticeListResponseDTO.fromJson(Map<String, dynamic> json) {
    return NoticeListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<NoticeData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}