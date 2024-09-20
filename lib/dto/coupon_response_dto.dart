import 'package:BliU/data/coupon_data.dart';

class CouponResponseDTO {
  final bool? result;
  final String? message;
  final List<CouponData>? list;

  CouponResponseDTO({
    required this.result,
    required this.message,
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
      list: list,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'list': list?.map((it) => it.toJson()).toList()
      },
    };
  }
}