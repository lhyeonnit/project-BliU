import 'package:BliU/data/delivery_detail_data.dart';

class DeliveryData {
  final int? deliveryPrice;
  final DeliveryDetailData? deliveryDetail;

  DeliveryData({
    required this.deliveryPrice,
    required this.deliveryDetail,
  });

  // JSON to Object
  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
      deliveryPrice: json['delivery_price'],
      deliveryDetail: DeliveryDetailData.fromJson(json['delivery_detail']),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'delivery_price': deliveryPrice,
      'delivery_detail': deliveryDetail,
    };
  }
}