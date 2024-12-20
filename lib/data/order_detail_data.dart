class OrderDetailData {
  final String? type;
  final int? ctIdx;
  final int? ctStats;
  final int? ctStatus;
  final String? ctStatusTxt;
  final String? otCode;
  final String? odtCode;
  final String? stName;
  final int? ptIdx;
  final String? ptName;
  final String? ctOptName;
  final String? ctOptValue;
  final int? ctOptQty;
  final int? ptPrice;
  final String? ptImg;
  String? reviewWrite;
  final int? rtIdx;
  final String? ptType;

  OrderDetailData({
    required this.type,
    required this.ctIdx,
    required this.ctStats,
    required this.ctStatus,
    required this.ctStatusTxt,
    required this.otCode,
    required this.odtCode,
    required this.stName,
    required this.ptIdx,
    required this.ptName,
    required this.ctOptName,
    required this.ctOptValue,
    required this.ctOptQty,
    required this.ptPrice,
    required this.ptImg,
    required this.reviewWrite,
    required this.rtIdx,
    required this.ptType,
  });

  // JSON to Object
  factory OrderDetailData.fromJson(Map<String, dynamic> json) {

    return OrderDetailData(
      type: json['type'],
      ctIdx: json['ct_idx'],
      ctStats: json['ct_stats'],
      ctStatus: json['ct_status'],
      ctStatusTxt: json['ct_status_txt'],
      otCode: json['ot_code'],
      odtCode: json['odt_code'],
      stName: json['st_name'],
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
      ctOptName: json['ct_opt_name'],
      ctOptValue: json['ct_opt_value'],
      ctOptQty: json['ct_opt_qty'],
      ptPrice: json['pt_price'],
      ptImg: json['pt_img'],
      reviewWrite: json['review_write'],
      rtIdx: json['rt_idx'],
      ptType: json['pt_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'ct_idx': ctIdx,
      'ct_stats': ctStats,
      'ct_status': ctStatus,
      'ct_status_txt': ctStatusTxt,
      'ot_code': otCode,
      'odt_code': odtCode,
      'st_name': stName,
      'pt_idx': ptIdx,
      'pt_name': ptName,
      'ct_opt_name': ctOptName,
      'ct_opt_value': ctOptValue,
      'ct_opt_qty': ctOptQty,
      'pt_price': ptPrice,
      'pt_img': ptImg,
      'review_write': reviewWrite,
      'rt_idx': rtIdx,
      'pt_type': ptType,
    };
  }
}