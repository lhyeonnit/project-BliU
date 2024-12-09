class CartItemData {
  final int? ctIdx;
  final int? ptIdx;
  final String? ptDeliveryNow;
  final String? ptName;
  final String? ptTitle;
  final int? ptCount;
  final int? ptJaego;
  final String? ptImg;
  final String? sellStatus;
  final String? sellStatusTxt;
  final int? ptPrice;
  final int? allPtPrice;
  final String? ptOption;
  final int? ctDeliveryDefaultPrice;
  final String? ctOptName;
  final String? ctOptValue;
  final int? ctOptQty;
  final int? ctPrice;
  final int? ctAllPrice;

  CartItemData({
    required this.ctIdx,
    required this.ptIdx,
    required this.ptDeliveryNow,
    required this.ptName,
    required this.ptTitle,
    required this.ptCount,
    required this.ptJaego,
    required this.ptImg,
    required this.sellStatus,
    required this.sellStatusTxt,
    required this.ptPrice,
    required this.allPtPrice,
    required this.ptOption,
    required this.ctDeliveryDefaultPrice,
    required this.ctOptName,
    required this.ctOptValue,
    required this.ctOptQty,
    required this.ctPrice,
    required this.ctAllPrice,
  });

  // JSON to Object
  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      ctIdx: json['ct_idx'],
      ptIdx: json['pt_idx'],
      ptDeliveryNow: json['pt_delivery_now'],
      ptName: json['pt_name'],
      ptTitle: json['pt_title'],
      ptCount: json['pt_count'],
      ptJaego: json['pt_jaego'],
      ptImg: json['pt_img'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
      ptPrice: json['pt_price'],
      allPtPrice: json['all_pt_price'],
      ptOption: json['pt_option'],
      ctDeliveryDefaultPrice: json['ct_delivery_default_price'],
      ctOptName: json['ct_opt_name'],
      ctOptValue: json['ct_opt_value'],
      ctOptQty: json['ct_opt_qty'],
      ctPrice: json['ct_price'],
      ctAllPrice: json['ct_all_price'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'pt_idx': ptIdx,
      'pt_delivery_now': ptDeliveryNow,
      'pt_name': ptName,
      'pt_title': ptTitle,
      'pt_count': ptCount,
      'pt_jaego': ptJaego,
      'pt_img': ptImg,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
      'pt_price': ptPrice,
      'all_pt_price': allPtPrice,
      'pt_option': ptOption,
      'ct_delivery_default_price': ctDeliveryDefaultPrice,
      'ct_opt_name': ctOptName,
      'ct_opt_value': ctOptValue,
      'ct_opt_qty': ctOptQty,
      'ct_price': ctPrice,
      'ct_all_price': ctAllPrice,
    };
  }
}