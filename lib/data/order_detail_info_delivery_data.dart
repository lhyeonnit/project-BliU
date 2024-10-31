class OrderDetailInfoDeliveryData {
  final String? otRname;
  final String? otRtel;
  final String? otRzip;
  final String? otRadd1;
  final String? otRadd2;
  final String? otRmemo1;
  final String? octMemo;

  OrderDetailInfoDeliveryData({
    required this.otRname,
    required this.otRtel,
    required this.otRzip,
    required this.otRadd1,
    required this.otRadd2,
    required this.otRmemo1,
    required this.octMemo,
  });

  // JSON to Object
  factory OrderDetailInfoDeliveryData.fromJson(Map<String, dynamic> json) {
    return OrderDetailInfoDeliveryData(
      otRname: json['ot_rname'],
      otRtel: json['ot_rtel'],
      otRzip: json['ot_rzip'],
      otRadd1: json['ot_radd1'],
      otRadd2: json['ot_radd2'],
      otRmemo1: json['ot_rmemo1'],
      octMemo: json['oct_memo'],

    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ot_rname': otRname,
      'ot_rtel': otRtel,
      'ot_rzip': otRzip,
      'ot_radd1': otRadd1,
      'ot_radd2': otRadd2,
      'ot_rmemo1': otRmemo1,
      'oct_memo': octMemo,
    };
  }
}