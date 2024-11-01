import 'package:BliU/data/return_info_data.dart';

class OrderCancelReturnDetailDTO {
  final bool? result;
  final String? message;
  final ReturnInfoData? data;

  OrderCancelReturnDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });
  // JSON to Object
  factory OrderCancelReturnDetailDTO.fromJson(Map<String, dynamic> json) {
    return OrderCancelReturnDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: ReturnInfoData.fromJson(json['data']),
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