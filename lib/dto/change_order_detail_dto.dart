import 'package:BliU/data/change_order_detail_data.dart';

class ChangeOrderDetailDTO {
  final bool? result;
  final String? message;
  final ChangeOrderDetailData? data;

  ChangeOrderDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });
  // JSON to Object
  factory ChangeOrderDetailDTO.fromJson(Map<String, dynamic> json) {
    return ChangeOrderDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: ChangeOrderDetailData.fromJson(json['data']),
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