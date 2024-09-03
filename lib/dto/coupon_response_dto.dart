import 'package:BliU/data/coupon_data.dart';

class CouponResponseDTO {
  final bool? result;
  final String? message;
  final List<CouponData>? data;

  CouponResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory CouponResponseDTO.fromJson(Map<String, dynamic> json) {
    return CouponResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as List<CouponData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.map((it) => it.toJson()).toList(),
    };
  }
}