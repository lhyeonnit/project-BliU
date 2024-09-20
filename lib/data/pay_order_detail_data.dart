import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/user_delivey_add_data.dart';

class PayOrderDetailData {
  final int? otIdx;
  final String? otCode;
  final List<CartData>? list;
  final int? myPoint;
  final int? maxUsePoint;
  final int? allPrice;
  final int? allDeliveryPrice;
  final UserDeliveyAddData? userDeliveyAdd;

  PayOrderDetailData({
    required this.otIdx,
    required this.otCode,
    required this.list,
    required this.myPoint,
    required this.maxUsePoint,
    required this.allPrice,
    required this.allDeliveryPrice,
    required this.userDeliveyAdd,
  });

  // JSON to Object
  factory PayOrderDetailData.fromJson(Map<String, dynamic> json) {
    final list = List<CartData>.from((json['list'])?.map((item) {
      return CartData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return PayOrderDetailData(
      otIdx: json['ot_idx'],
      otCode: json['ot_code'],
      list: list,
      myPoint: json['my_point'],
      maxUsePoint: json['max_use_point'],
      allPrice: json['all_price'],
      allDeliveryPrice: json['all_delivery_price'],
      userDeliveyAdd: UserDeliveyAddData.fromJson(json['user_delivey_add']),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ot_idx': otIdx,
      'ot_code': otCode,
      'list': list?.map((it) => it.toJson()).toList(),
      'my_point': myPoint,
      'max_use_point': maxUsePoint,
      'all_price': allPrice,
      'all_delivery_price': allDeliveryPrice,
      'user_delivey_add': userDeliveyAdd,
    };
  }
}