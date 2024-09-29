class CartItemData {
  final int? ctIdx;
  final String? ptName;
  final String? ptTitle;
  final int? ptCount;
  final String? ptImg;
  final String? sellStatus;
  final String? sellStatusTxt;
  final int? ptPrice;
  final int? allPtPrice;
  final String? ptOption;
  final int? ctDeliveryDefaultPrice;
  bool isSelected = false;

  CartItemData({
    required this.ctIdx,
    required this.ptName,
    required this.ptTitle,
    required this.ptCount,
    required this.ptImg,
    required this.sellStatus,
    required this.sellStatusTxt,
    required this.ptPrice,
    required this.allPtPrice,
    required this.ptOption,
    required this.ctDeliveryDefaultPrice,
  });

  // JSON to Object
  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      ctIdx: json['ct_idx'],
      ptName: json['pt_name'],
      ptTitle: json['pt_title'],
      ptCount: json['pt_count'],
      ptImg: json['pt_img'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
      ptPrice: json['pt_price'],
      allPtPrice: json['all_pt_price'],
      ptOption: json['pt_option'],
      ctDeliveryDefaultPrice: json['ct_delivery_default_price'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'pt_name': ptName,
      'pt_title': ptTitle,
      'pt_count': ptCount,
      'pt_img': ptImg,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
      'pt_price': ptPrice,
      'all_pt_price': allPtPrice,
      'pt_option': ptOption,
      'ct_delivery_default_price': ctDeliveryDefaultPrice,
    };
  }
}