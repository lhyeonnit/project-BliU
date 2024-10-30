import 'package:BliU/data/exchange_return_detail_data.dart';

class ExchangeReturnDetailDTO {
  final bool? result;
  final String? message;
  final ExchangeReturnDetailData? data;

  ExchangeReturnDetailDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory ExchangeReturnDetailDTO.fromJson(Map<String, dynamic> json) {
    return ExchangeReturnDetailDTO(
      result: json['result'],
      message: json['data']['message'],
      data: ExchangeReturnDetailData.fromJson(json['data']),
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