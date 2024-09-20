import 'package:BliU/data/pay_order_detail_data.dart';

class PayOrderDetailDTO {
  final bool? result;
  final String? message;
  final PayOrderDetailData? data;

  PayOrderDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory PayOrderDetailDTO.fromJson(Map<String, dynamic> json) {
    return PayOrderDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: PayOrderDetailData.fromJson(json['data']),
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