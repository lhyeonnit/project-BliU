import 'package:BliU/data/dto/review_data.dart';

class ReviewInfoDTO {
  final int? starAvg;
  final int? reviewCount;

  ReviewInfoDTO({
    required this.starAvg,
    required this.reviewCount,
  });

  // JSON to Object
  factory ReviewInfoDTO.fromJson(Map<String, dynamic> json) {
    return ReviewInfoDTO(
      starAvg: json['star_avg'],
      reviewCount: json['review_count'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'star_avg': starAvg,
      'review_count': reviewCount,
    };
  }
}

class ReviewInfoResponseDTO {
  final bool? result;
  final String? message;
  final ReviewInfoDTO? reviewInfo;
  final List<ReviewDTO>? list;

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
      list: (json['data']['list'] as List<ReviewDTO>),
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