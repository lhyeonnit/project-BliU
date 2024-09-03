import 'package:BliU/data/qna_data.dart';

class ProductQnaListResponseDto {
  final bool? result;
  final String? message;
  final List<QnaData>? data;

  ProductQnaListResponseDto({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory ProductQnaListResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductQnaListResponseDto(
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