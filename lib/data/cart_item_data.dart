class CartItemData {
  final int? ctIdx;
  final String? ptTitle;
  final int? ptCount;
  final String? ptImg;
  final String? sellStatus;
  final String? sellStatusTxt;
  final int? ptPrice;
  final String? ptOption;

  CartItemData({
    required this.ctIdx,
    required this.ptTitle,
    required this.ptCount,
    required this.ptImg,
    required this.sellStatus,
    required this.sellStatusTxt,
    required this.ptPrice,
    required this.ptOption,
  });

  // JSON to Object
  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      ctIdx: json['ct_idx'],
      ptTitle: json['pt_title'],
      ptCount: json['pt_count'],
      ptImg: json['pt_img'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
      ptPrice: json['pt_price'],
      ptOption: json['pt_option'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'pt_title': ptTitle,
      'pt_count': ptCount,
      'pt_img': ptImg,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
      'pt_price': ptPrice,
      'pt_option': ptOption,
    };
  }
}