import 'package:BliU/data/product_option_data.dart';

class ProductOptionResponseDTO {
  final bool? result;
  final String? message;
  final ProductOptionData? data;

  ProductOptionResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory ProductOptionResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductOptionResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as ProductOptionData),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson()
    };
  }
}