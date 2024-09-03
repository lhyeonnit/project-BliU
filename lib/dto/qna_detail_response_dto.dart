import 'package:BliU/data/qna_data.dart';

class QnaDetailResponseDTO {
  final bool? result;
  final String? message;
  final QnaData? data;

  QnaDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory QnaDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return QnaDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as QnaData),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : data
    };
  }
}