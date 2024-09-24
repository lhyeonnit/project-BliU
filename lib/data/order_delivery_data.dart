import 'package:BliU/data/order_delivery_history_data.dart';

class OrderDeliveryData {
  final String? ctDeliveryCom;
  final String? ctDeliveryNumber;
  final List<OrderDeliveryHistoryData>? delivery;

  OrderDeliveryData({
    required this.ctDeliveryCom,
    required this.ctDeliveryNumber,
    required this.delivery,
  });

  // JSON to Object
  factory OrderDeliveryData.fromJson(Map<String, dynamic> json) {
    List<OrderDeliveryHistoryData> delivery = [];
    if (json['delivery'] != null)  {
      delivery = List<OrderDeliveryHistoryData>.from((json['delivery'])?.map((item) {
        return OrderDeliveryHistoryData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    return OrderDeliveryData(
      ctDeliveryCom: json['ct_delivery_com'],
      ctDeliveryNumber: json['ct_delivery_number'],
      delivery: delivery,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_delivery_com': ctDeliveryCom,
      'ct_delivery_number': ctDeliveryNumber,
      'delivery': delivery?.map((it) => it.toJson()).toList(),
    };
  }
}