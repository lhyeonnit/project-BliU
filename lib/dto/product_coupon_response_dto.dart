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
    final list = List<ProductCouponData>.from((json['data']['list'])?.map((item) {
      return ProductCouponData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return ProductCouponResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      downAbleCount: json['downAbleCount'],
      list: list,
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