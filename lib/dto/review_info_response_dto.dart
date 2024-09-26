import 'package:BliU/data/review_data.dart';
import 'package:BliU/data/review_info_data.dart';

class ReviewInfoResponseDTO {
  final bool? result;
  final String? message;
  final ReviewInfoData? reviewInfo;
  List<ReviewData>? list;

  ReviewInfoResponseDTO({
    required this.result,
    required this.message,
    required this.reviewInfo,
    required this.list,
  });

  // JSON to Object
  factory ReviewInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<ReviewData>.from((json['data']['list'])?.map((item) {
      return ReviewData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return ReviewInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      reviewInfo: ReviewInfoData.fromJson(json['data']['review_info']),
      list: list,
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