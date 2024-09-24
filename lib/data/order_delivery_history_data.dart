class OrderDeliveryHistoryData {
  final String? kind;
  final String? where;
  final String? time;

  OrderDeliveryHistoryData({
    required this.kind,
    required this.where,
    required this.time,
  });

  // JSON to Object
  factory OrderDeliveryHistoryData.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryHistoryData(
      kind: json['kind'],
      where: json['where'],
      time: json['time'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'where': where,
      'time': time,
    };
  }
}