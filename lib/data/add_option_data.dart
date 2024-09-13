class AddOptionData {
  final int? idx;
  final String? option;
  final int? patPrice;

  AddOptionData({
    required this.idx,
    required this.option,
    required this.patPrice,
  });

  // JSON to Object
  factory AddOptionData.fromJson(Map<String, dynamic> json) {
    return AddOptionData(
      idx: json['idx'],
      option: json['option'],
      patPrice: json['pat_price'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'option': option,
      'pat_price': patPrice,
    };
  }
}