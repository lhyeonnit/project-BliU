class ProductCouponData {
  final String? ctName;
  final String? ctCode;
  final String? couponDiscount;
  final int? ctPrice;
  final int? ctMinPrice;
  final int? ctMaxPrice;
  final String? ctDate;
  String? down;

  ProductCouponData({
    required this.ctName,
    required this.ctCode,
    required this.couponDiscount,
    required this.ctPrice,
    required this.ctMinPrice,
    required this.ctMaxPrice,
    required this.ctDate,
    required this.down,
  });

  // JSON to Object
  factory ProductCouponData.fromJson(Map<String, dynamic> json) {
    return ProductCouponData(
      ctName: json['ct_name'],
      ctCode: json['ct_code'],
      couponDiscount: json['coupon_discount'],
      ctPrice: json['ct_price'],
      ctMinPrice: json['ct_min_price'],
      ctMaxPrice: json['ct_max_price'],
      ctDate: json['ct_date'],
      down: json['down'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_name': ctName,
      'ct_code': ctCode,
      'coupon_discount': couponDiscount,
      'ct_price': ctPrice,
      'ct_min_price': ctMinPrice,
      'ct_max_price': ctMaxPrice,
      'ct_date': ctDate,
      'down': down,

    };
  }
}