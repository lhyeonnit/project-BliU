import 'package:BliU/data/push_data.dart';

class PushResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<PushData>? list;

  PushResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list,
  });

  // JSON to Object
  factory PushResponseDTO.fromJson(Map<String, dynamic> json) {
    return PushResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<PushData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : {
        'count': list?.length,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}