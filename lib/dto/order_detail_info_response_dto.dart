import 'package:BliU/data/order_detail_info_data.dart';

class OrderDetailInfoResponseDTO {
  final bool? result;
  final String? message;
  OrderDetailInfoData data;

  OrderDetailInfoResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory OrderDetailInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return OrderDetailInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: OrderDetailInfoData.fromJson(json['data']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data.toJson(),
    };
  }
}