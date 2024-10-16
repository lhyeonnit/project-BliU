import 'package:BliU/data/coupon_data.dart';

class CouponResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final int? downAbleCount;
  final List<CouponData>? list;

  CouponResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.downAbleCount,
    required this.list
  });

  // JSON to Object
  factory CouponResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<CouponData>.from((json['data']['list'])?.map((item) {
      return CouponData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return CouponResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      downAbleCount: json['data']['downAbleCount'],
      list: list,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'downAbleCount': downAbleCount,
        'list': list?.map((it) => it.toJson()).toList()
      },
    };
  }
}