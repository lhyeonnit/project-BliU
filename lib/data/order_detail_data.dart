class OrderDetailData {
  final int? ctIdx;
  final int? ctStats;
  final String? ctStatusTxt;
  final String? otCode;
  final String? odtCode;
  final String? ptName;
  final String? ctOptName;
  final String? ctOptValue;
  final int? ctOptQty;
  final int? ptPrice;
  final String? ptImg;

  OrderDetailData({
    required this.ctIdx,
    required this.ctStats,
    required this.ctStatusTxt,
    required this.otCode,
    required this.odtCode,
    required this.ptName,
    required this.ctOptName,
    required this.ctOptValue,
    required this.ctOptQty,
    required this.ptPrice,
    required this.ptImg,
  });

  // JSON to Object
  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    return OrderDetailData(
      ctIdx: json['ct_idx'],
      ctStats: json['ct_stats'],
      ctStatusTxt: json['ct_status_txt'],
      otCode: json['ot_code'],
      odtCode: json['odt_code'],
      ptName: json['pt_name'],
      ctOptName: json['ct_opt_name'],
      ctOptValue: json['ct_opt_value'],
      ctOptQty: json['ct_opt_qty'],
      ptPrice: json['pt_price'],
      ptImg: json['pt_img'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'ct_stats': ctStats,
      'ct_status_txt': ctStatusTxt,
      'ot_code': otCode,
      'odt_code': odtCode,
      'pt_name': ptName,
      'ct_opt_name': ctOptName,
      'ct_opt_value': ctOptValue,
      'ct_opt_qty': ctOptQty,
      'pt_price': ptPrice,
      'pt_img': ptImg,
    };
  }
}