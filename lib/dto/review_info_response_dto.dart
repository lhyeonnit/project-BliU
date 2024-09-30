import 'package:BliU/data/review_data.dart';
import 'package:BliU/data/review_info_data.dart';

class ReviewInfoResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final ReviewInfoData? reviewInfo;
  List<ReviewData>? list;

  ReviewInfoResponseDTO({
    required this.result,
    required this.message,
    this.count,
    this.reviewInfo,
    this.list,
  });

  // JSON to Object
  factory ReviewInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<ReviewData>.from((json['data']['list'])?.map((item) {
      return ReviewData.fromJson(item as Map<String, dynamic>);
    }).toList());

    ReviewInfoData? reviewInfo;
    if (json['data']['review_info'] != null) {
      reviewInfo = ReviewInfoData.fromJson(json['data']['review_info']);
    }

    return ReviewInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      reviewInfo: reviewInfo,
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
        'review_info': reviewInfo,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}