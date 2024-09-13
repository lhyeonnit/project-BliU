import 'package:BliU/data/qna_data.dart';

class QnaListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  List<QnaData>? list;

  QnaListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list,
  });

  // JSON to Object
  factory QnaListResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<QnaData>.from((json['data']['list'])?.map((item) {
      return QnaData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return QnaListResponseDTO(
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