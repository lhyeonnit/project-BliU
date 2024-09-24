import 'package:BliU/data/order_data.dart';

class OrderResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  List<OrderData>? list;

  OrderResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory OrderResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<OrderData>.from((json['data']['list'])?.map((item) {
      return OrderData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return OrderResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: list,
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