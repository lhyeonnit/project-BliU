import 'package:BliU/data/order_detail_data.dart';

class CancelInfoData {
  final List<OrderDetailData>? cancelList;
  final int? otUseCoupon;
  final int? octReturnPoint;
  final int? deliveryPriece;
  final int? octReturnPrice;
  final String? octReturnType;
  final String? octAll;
  final String? cancelItem;
  final String? couponName;

  CancelInfoData({
    required this.cancelList,
    required this.otUseCoupon,
    required this.octReturnPoint,
    required this.deliveryPriece,
    required this.octReturnPrice,
    required this.octReturnType,
    required this.octAll,
    required this.cancelItem,
    required this.couponName,
  });

  // JSON to Object
  factory CancelInfoData.fromJson(Map<String, dynamic> json) {
    List<OrderDetailData> cancelList = [];

    cancelList = List<OrderDetailData>.from((json['cancel_list'])?.map((item) {
      return OrderDetailData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return CancelInfoData(
      cancelList: cancelList,
      otUseCoupon: json['ot_use_coupon'],
      octReturnPoint: json['oct_return_point'],
      deliveryPriece: json['delivery_priece'],
      octReturnPrice: json['oct_return_price'],
      octReturnType: json['oct_return_type'],
      octAll: json['oct_all'],
      cancelItem: json['cancel_item'],
      couponName: json['coupon_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'cancel_list': cancelList?.map((it) => it.toJson()).toList(),
      'ot_use_coupon': otUseCoupon,
      'oct_return_point': octReturnPoint,
      'delivery_priece': deliveryPriece,
      'oct_return_price': octReturnPrice,
      'oct_return_type': octReturnType,
      'oct_all': octAll,
      'cancel_item': cancelItem,
      'coupon_name': couponName,
    };
  }
}
