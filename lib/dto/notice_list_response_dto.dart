import 'package:BliU/data/notice_data.dart';

class NoticeListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  List<NoticeData>? list;

  NoticeListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory NoticeListResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<NoticeData>.from((json['data']['list'])?.map((item) {
      return NoticeData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return NoticeListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: list,
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