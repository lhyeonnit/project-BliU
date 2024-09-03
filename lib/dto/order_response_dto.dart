import 'package:BliU/data/order_data.dart';

class OrderResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<OrderData>? list;

  OrderResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory OrderResponseDTO.fromJson(Map<String, dynamic> json) {
    return OrderResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<OrderData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}