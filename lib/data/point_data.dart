class PointData {
  final String? pltWdate;
  final String? pltType;
  final String? pltTypeTxt;
  final String? pltPrice;
  final String? pltMemo;

  PointData({
    required this.pltWdate,
    required this.pltType,
    required this.pltTypeTxt,
    required this.pltPrice,
    required this.pltMemo,
  });

  factory PointData.fromJson(Map<String, dynamic> json) {

    return PointData(
      pltWdate: json['plt_wdate'],
      pltType: json['plt_type'],
      pltTypeTxt: json['plt_type_txt'],
      pltPrice: json['plt_price'],
      pltMemo: json['plt_memo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'plt_wdate' : pltWdate,
    'plt_type' : pltType,
    'plt_type_txt' : pltTypeTxt,
    'plt_price' : pltPrice,
    'plt_memo' : pltMemo,
  };
}