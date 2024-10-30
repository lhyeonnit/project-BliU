import 'package:BliU/data/cancel_detail_data.dart';

class CancelDetailDTO {
  final bool? result;
  final String? message;
  final CancelDetailData? data;

  CancelDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory CancelDetailDTO.fromJson(Map<String, dynamic> json) {
    return CancelDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: CancelDetailData.fromJson(json['data']),
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