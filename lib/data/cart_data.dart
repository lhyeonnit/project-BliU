import 'package:BliU/data/cart_item_data.dart';

class CartData {
  final int? stIdx;
  final String? stName;
  final String? stProfile;
  final int? stProductPrice;
  final int? stDeliveryPrice;
  final List<CartItemData>? productList;

  CartData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stProductPrice,
    required this.stDeliveryPrice,
    required this.productList,
  });

  // JSON to Object
  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stProductPrice: json['st_product_price'],
      stDeliveryPrice: json['st_delivery_price'],
      productList: (json['product_list'] as List<CartItemData>),
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