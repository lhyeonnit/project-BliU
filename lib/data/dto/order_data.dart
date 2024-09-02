import 'package:BliU/data/dto/order_detail_data.dart';

class OrderDTO {
  final String? ctWdate;
  final List<OrderDetailDTO>? detailList;

  OrderDTO({
    required this.ctWdate,
    required this.detailList,
  });

  // JSON to Object
  factory OrderDTO.fromJson(Map<String, dynamic> json) {
    return OrderDTO(
      ctWdate: json['ct_wdate'],
      detailList: (json['detail_list'] as List<OrderDetailDTO>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_wdate': ctWdate,
      'detail_list': detailList?.map((it) => it.toJson()).toList(),
    };
  }
}

class OrderResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<OrderDTO>? list;

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
      list: (json['data']['list'] as List<OrderDTO>),
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