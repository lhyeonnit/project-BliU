class ReturnInfoData {
  final int? deliveryPrice;
  final int? octReturnPoint;
  final int? octDeliveryReturn;
  final int? octReturnPrice;
  final String? octReturnType;
  final int? ortReturnPoint;
  final int? ortDeliveryReturn;
  final int? ortReturnPrice;
  final String? ortReturnType;

  ReturnInfoData({
    required this.deliveryPrice,
    required this.octReturnPoint,
    required this.octDeliveryReturn,
    required this.octReturnPrice,
    required this.octReturnType,
    required this.ortReturnPoint,
    required this.ortDeliveryReturn,
    required this.ortReturnPrice,
    required this.ortReturnType,
  });

  // JSON to Object
  factory ReturnInfoData.fromJson(Map<String, dynamic> json) {
    return ReturnInfoData(
      deliveryPrice: json['delivery_priece'],
      octReturnPoint: json['oct_return_point'],
      octDeliveryReturn: json['oct_delivery_return'],
      octReturnPrice: json['oct_return_price'],
      octReturnType: json['oct_return_type'],
      ortReturnPoint: json['ort_return_point'],
      ortDeliveryReturn: json['ort_delivery_return'],
      ortReturnPrice: json['ort_return_price'],
      ortReturnType: json['ort_return_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'oct_return_point': octReturnPoint,
      'oct_delivery_return': octDeliveryReturn,
      'oct_return_price': octReturnPrice,
      'oct_return_type': octReturnType,
      'ort_return_point': ortReturnPoint,
      'ort_delivery_return': ortDeliveryReturn,
      'ort_return_price': ortReturnPrice,
      'ort_return_type': ortReturnType,
    };
  }
}