class ProductOptionTypeDetailData {
  final int? idx;
  final String? option;
  final int? potPrice;
  final int? potJaego;
  int count = 1;

  ProductOptionTypeDetailData({
    required this.idx,
    required this.option,
    required this.potPrice,
    required this.potJaego,
  });

  // JSON to Object
  factory ProductOptionTypeDetailData.fromJson(Map<String, dynamic> json) {
    return ProductOptionTypeDetailData(
      idx: json['idx'],
      option: json['option'],
      potPrice: json['pot_price'],
      potJaego: json['pot_jaego'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'option': option,
      'pot_price': potPrice,
      'pot_jaego': potJaego,
    };
  }
}