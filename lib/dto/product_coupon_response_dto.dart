import 'package:BliU/data/product_coupon_data.dart';

class ProductCouponResponseDTO {
  final bool? result;
  final String? message;
  final int? downAbleCount;
  final List<ProductCouponData>? list;

  ProductCouponResponseDTO({
    required this.result,
    required this.message,
    required this.downAbleCount,
    required this.list
  });

  // JSON to Object
  factory ProductCouponResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductCouponResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      downAbleCount: json['downAbleCount'],
      list: (json['data']['list'] as List<ProductCouponData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'downAbleCount' : downAbleCount,
        'list': list?.map((it) => it.toJson()).toList(),
      },
    };
  }
}