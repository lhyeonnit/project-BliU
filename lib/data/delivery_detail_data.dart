class DeliveryDetailData {
  final String? deliveryCompany;
  final int? deliveryBasicPrice;
  final int? deliveryMinPrice;
  final int? deliveryAddPrice1;
  final int? deliveryAddPrice2;

  DeliveryDetailData({
    required this.deliveryCompany,
    required this.deliveryBasicPrice,
    required this.deliveryMinPrice,
    required this.deliveryAddPrice1,
    required this.deliveryAddPrice2,
  });

  // JSON to Object
  factory DeliveryDetailData.fromJson(Map<String, dynamic> json) {
    return DeliveryDetailData(
      deliveryCompany: json['delivery_company'],
      deliveryBasicPrice: json['delivery_basic_price'],
      deliveryMinPrice: json['delivery_min_price'],
      deliveryAddPrice1: json['delivery_add_price1'],
      deliveryAddPrice2: json['delivery_add_price2'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'delivery_company': deliveryCompany,
      'delivery_basic_price': deliveryBasicPrice,
      'delivery_min_price': deliveryMinPrice,
      'delivery_add_price1': deliveryAddPrice1,
      'delivery_add_price2': deliveryAddPrice2,
    };
  }
}