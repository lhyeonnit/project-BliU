import 'package:BliU/data/qna_data.dart';

class QnaResponseDTO {
  final bool? result;
  final String? message;
  final List<QnaData>? data;

  QnaResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory QnaResponseDTO.fromJson(Map<String, dynamic> json) {
    return QnaResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as List<QnaData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : data?.map((it) => it.toJson()).toList(),
    };
  }
}