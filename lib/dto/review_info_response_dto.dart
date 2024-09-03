import 'package:BliU/data/review_data.dart';
import 'package:BliU/data/review_info_data.dart';

class ReviewInfoResponseDTO {
  final bool? result;
  final String? message;
  final ReviewInfoData? reviewInfo;
  final List<ReviewData>? list;

  ReviewInfoResponseDTO({
    required this.result,
    required this.message,
    required this.reviewInfo,
    required this.list,
  });

  // JSON to Object
  factory ReviewInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return ReviewInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      reviewInfo: json['data']['review_info'],
      list: (json['data']['list'] as List<ReviewData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : {
        'review_info': reviewInfo,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}