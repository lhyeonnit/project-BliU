import 'package:BliU/data/product_coupon_data.dart';

class StoreDownloadResponseDTO {
  final bool? result;
  final String? message;

  StoreDownloadResponseDTO({
    required this.result,
    required this.message,
  });

  // JSON to Object
  factory StoreDownloadResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<ProductCouponData>.from((json['data']['list'])?.map((item) {
      return ProductCouponData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return StoreDownloadResponseDTO(
      result: json['result'],
      message: json['data']['message'],
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {

      },
    };
  }
}