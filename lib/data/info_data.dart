class InfoData {
  final String? delivery;
  final String? returnVal;

  InfoData({
    required this.delivery,
    required this.returnVal,
  });

  // JSON to Object
  factory InfoData.fromJson(Map<String, dynamic> json) {
    return InfoData(
      delivery: json['delivery'],
      returnVal: json['return'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'delivery': delivery,
      'return': returnVal,
    };
  }
}