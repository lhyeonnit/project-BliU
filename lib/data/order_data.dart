import 'package:BliU/data/order_detail_data.dart';

class OrderData {
  final String? ctWdate;
  final List<OrderDetailData>? detailList;

  OrderData({
    required this.ctWdate,
    required this.detailList,
  });

  // JSON to Object
  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      ctWdate: json['ct_wdate'],
      detailList: (json['detail_list'] as List<OrderDetailData>),
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