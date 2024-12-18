import 'package:BliU/data/cancel_info_data.dart';

class OrderCancelInfoResponseDto {
  final bool? result;
  final String? message;
  final CancelInfoData? data;

  OrderCancelInfoResponseDto({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory OrderCancelInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderCancelInfoResponseDto(
      result: json['result'],
      message: json['data']['message'],
      data: CancelInfoData.fromJson(json['data']),
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