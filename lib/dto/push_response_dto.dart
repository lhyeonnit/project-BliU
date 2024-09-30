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
    final list = List<PushData>.from((json['data']['list'])?.map((item) {
      return PushData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return PushResponseDTO(
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
      'data' : {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}