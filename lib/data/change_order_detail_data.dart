import 'package:BliU/data/change_order_detail_info_data.dart';
import 'package:BliU/data/return_info_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_delivery_data.dart';
import 'package:BliU/data/order_detail_info_order_data.dart';

class ChangeOrderDetailData {
  final int? cancelIdx;
  final String? ctWdate;
  final int? ctStatus;
  final String? ctStatusTxt;
  final String? octCancelMemo1;
  final String? octCancelMemo2;
  final int? returnIdx;
  final String? ortReturnMemo1;
  final String? ortReturnMemo2;
  final OrderDetailData? product;
  final ChangeOrderDetailInfoData? info;
  final ReturnInfoData? returnInfoData;
  final OrderDetailInfoDeliveryData? delivery;
  final OrderDetailInfoOrderData? order;


  ChangeOrderDetailData({
    required this.cancelIdx,
    required this.ctWdate,
    required this.ctStatus,
    required this.ctStatusTxt,
    required this.octCancelMemo1,
    required this.octCancelMemo2,
    required this.returnIdx,
    required this.ortReturnMemo1,
    required this.ortReturnMemo2,
    required this.product,
    required this.info,
    required this.returnInfoData,
    required this.delivery,
    required this.order,
  });

  // JSON to Object
  factory ChangeOrderDetailData.fromJson(Map<String, dynamic> json) {

    return ChangeOrderDetailData(
      cancelIdx: json['cancel_idx'],
      ctWdate: json['ct_wdate'],
      ctStatus: json['ct_stats'],
      ctStatusTxt: json['ct_status_txt'],
      octCancelMemo1: json['oct_cancel_memo1'],
      octCancelMemo2: json['oct_cancel_memo2'],
      returnIdx: json['return_idx'],
      ortReturnMemo1: json['ort_return_meno1'],
      ortReturnMemo2: json['ort_return_meno2'],
      product: OrderDetailData.fromJson(json['product']),
      info: ChangeOrderDetailInfoData.fromJson(json['info']),
      returnInfoData: ReturnInfoData.fromJson(json['return']),
      delivery: OrderDetailInfoDeliveryData.fromJson(json['delivery']),
      order: OrderDetailInfoOrderData.fromJson(json['order']),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'cancel_idx': cancelIdx,
      'ct_wdate': ctWdate,
      'ct_stats': ctStatus,
      'ct_status_txt': ctStatusTxt,
      'oct_cancel_memo1': octCancelMemo1,
      'oct_cancel_memo2': octCancelMemo2,
      'return_idx': returnIdx,
      'ort_return_meno1': ortReturnMemo1,
      'ort_return_meno2': ortReturnMemo2,
      'product': product?.toJson(),
      'info': info?.toJson(),
      'return': returnInfoData?.toJson(),
      'delivery': delivery?.toJson(),
      'order': order?.toJson(),
    };
  }
}