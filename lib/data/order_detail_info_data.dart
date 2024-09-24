import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_delivery_data.dart';
import 'package:BliU/data/order_detail_info_order_data.dart';

class OrderDetailInfoData {
  final List<OrderDetailData>? product;
  final OrderDetailInfoDeliveryData? delivery;
  final OrderDetailInfoOrderData? order;

  OrderDetailInfoData({
    required this.product,
    required this.delivery,
    required this.order,
  });

  // JSON to Object
  factory OrderDetailInfoData.fromJson(Map<String, dynamic> json) {
    final product = List<OrderDetailData>.from((json['product'])?.map((item) {
      return OrderDetailData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return OrderDetailInfoData(
      product: product,
      delivery: OrderDetailInfoDeliveryData.fromJson(json['delivery']),
      order: OrderDetailInfoOrderData.fromJson(json['order']),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'delivery': delivery?.toJson(),
      'order': order?.toJson(),
    };
  }
}