import 'package:BliU/data/order_delivery_data.dart';

class OrderDeliveryResponseDTO {
  final bool? result;
  final String? message;
  OrderDeliveryData? data;

  OrderDeliveryResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory OrderDeliveryResponseDTO.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: OrderDeliveryData.fromJson(json['data']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}