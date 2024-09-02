class ProductOptionTypeDetailDTO {
  final int? idx;
  final String? option;
  final int? potPrice;
  final int? potJaego;

  ProductOptionTypeDetailDTO({
    required this.idx,
    required this.option,
    required this.potPrice,
    required this.potJaego,
  });

  // JSON to Object
  factory ProductOptionTypeDetailDTO.fromJson(Map<String, dynamic> json) {
    return ProductOptionTypeDetailDTO(
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