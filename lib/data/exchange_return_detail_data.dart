import 'package:BliU/data/order_detail_data.dart';

class ExchangeReturnDetailData {
  final String? ctWdate;
  final List<OrderDetailData>? detailList;

  ExchangeReturnDetailData({
    required this.ctWdate,
    required this.detailList,
  });

  // JSON to Object
  factory ExchangeReturnDetailData.fromJson(Map<String, dynamic> json) {
    final list = List<OrderDetailData>.from((json['detail_list'])?.map((item) {
      return OrderDetailData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return ExchangeReturnDetailData(
      ctWdate: json['ct_wdate'],
      detailList: list,
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