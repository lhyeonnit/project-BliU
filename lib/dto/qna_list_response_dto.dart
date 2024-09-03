import 'package:BliU/data/qna_data.dart';

class QnaListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<QnaData>? list;

  QnaListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list,
  });

  // JSON to Object
  factory QnaListResponseDTO.fromJson(Map<String, dynamic> json) {
    return QnaListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<QnaData>),
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