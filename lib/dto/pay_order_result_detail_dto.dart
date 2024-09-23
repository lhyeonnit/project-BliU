import 'package:BliU/data/pay_order_result_detail_data.dart';

class PayOrderResultDetailDTO {
  final bool? result;
  final String? message;
  final PayOrderResultDetailData? data;

  PayOrderResultDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory PayOrderResultDetailDTO.fromJson(Map<String, dynamic> json) {
    return PayOrderResultDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: PayOrderResultDetailData.fromJson(json['data']),
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