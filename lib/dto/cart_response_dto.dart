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
    final list = List<CartData>.from((json['data']['list'])?.map((item) {
      return CartData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return CartResponseDTO(
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
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}