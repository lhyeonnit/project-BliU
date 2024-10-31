class ReturnInfoData {
  final String? octReturnPoint;
  final String? octDeliveryReturn;
  final String? octReturnPrice;
  final String? octReturnType;

  ReturnInfoData({
    required this.octReturnPoint,
    required this.octDeliveryReturn,
    required this.octReturnPrice,
    required this.octReturnType,
  });

  // JSON to Object
  factory ReturnInfoData.fromJson(Map<String, dynamic> json) {
    return ReturnInfoData(
      octReturnPoint: json['oct_return_point'],
      octDeliveryReturn: json['oct_delivery_return'],
      octReturnPrice: json['oct_return_price'],
      octReturnType: json['oct_return_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'oct_return_point': octReturnPoint,
      'oct_delivery_return': octDeliveryReturn,
      'oct_return_price': octReturnPrice,
      'oct_return_type': octReturnType,
    };
  }
}