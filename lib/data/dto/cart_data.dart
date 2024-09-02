import 'package:BliU/data/dto/cart_item_data.dart';

class CartDTO {
  final int? stIdx;
  final String? stName;
  final String? stProfile;
  final int? stProductPrice;
  final int? stDeliveryPrice;
  final List<CartItemDTO>? productList;

  CartDTO({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stProductPrice,
    required this.stDeliveryPrice,
    required this.productList,
  });

  // JSON to Object
  factory CartDTO.fromJson(Map<String, dynamic> json) {
    return CartDTO(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stProductPrice: json['st_product_price'],
      stDeliveryPrice: json['st_delivery_price'],
      productList: (json['product_list'] as List<CartItemDTO>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_product_price': stProductPrice,
      'st_delivery_price': stDeliveryPrice,
      'product_list': productList?.map((it) => it.toJson()).toList(),
    };
  }
}

class CartResponseDTO {
  final bool? result;
  final String? message;
  final List<CartDTO>? list;

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
      list: (json['data']['list'] as List<CartDTO>),
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