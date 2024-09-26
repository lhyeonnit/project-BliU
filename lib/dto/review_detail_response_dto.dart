import 'package:BliU/data/review_data.dart';

class ReviewDetailResponseDTO {
  final bool? result;
  final String? message;
  final ReviewData? data;

  ReviewDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory ReviewDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return ReviewDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: ReviewData.fromJson(json['data']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : data?.toJson(),
    };
  }
}