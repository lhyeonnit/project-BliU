import 'package:BliU/data/cart_data.dart';

class CartResponseDTO {
  final bool? result;
  final String? message;
  final List<CartData>? list;

  CartResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory CartResponseDTO.fromJson(Map<String, dynamic> json) {
    return CartResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<CartData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}