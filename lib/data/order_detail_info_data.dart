import 'package:BliU/data/cancel_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_delivery_data.dart';
import 'package:BliU/data/order_detail_info_order_data.dart';

class OrderDetailInfoData {
  List<OrderDetailData>? product;
  final OrderDetailInfoDeliveryData? delivery;
  final OrderDetailInfoOrderData? order;
  final CancelData? cancel;

  OrderDetailInfoData({
    required this.product,
    required this.delivery,
    required this.order,
    required this.cancel,
  });

  // JSON to Object
  factory OrderDetailInfoData.fromJson(Map<String, dynamic> json) {
    List<OrderDetailData> product = [];
    if (json['product'] != null) {
      product = List<OrderDetailData>.from((json['product'])?.map((item) {
        return OrderDetailData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    OrderDetailInfoDeliveryData? delivery;
    if (json['delivery'] != null) {
      delivery = OrderDetailInfoDeliveryData.fromJson(json['delivery']);
    }


    OrderDetailInfoOrderData? order;
    if (json['order'] != null) {
      order = OrderDetailInfoOrderData.fromJson(json['order']);
    }


    CancelData? cancel;
    if (json['cancel'] != null) {
      cancel = CancelData.fromJson(json['cancel']);
    }

    return OrderDetailInfoData(
      product: product,
      delivery: delivery,
      order: order,
      cancel: cancel,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'product': product?.map((it) => it.toJson()).toList(),
      'delivery': delivery?.toJson(),
      'order': order?.toJson(),
      'cancel': cancel?.toJson(),
    };
  }
}