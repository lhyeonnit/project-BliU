class AddOptionData {
  final int? idx;
  final String? option;
  final int? patPrice;
  final int? patJaego;
  int count = 1;

  AddOptionData({
    required this.idx,
    required this.option,
    required this.patPrice,
    required this.patJaego,
  });

  // JSON to Object
  factory AddOptionData.fromJson(Map<String, dynamic> json) {
    return AddOptionData(
      idx: json['idx'],
      option: json['option'],
      patPrice: json['pat_price'],
      patJaego: json['pat_jaego'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'option': option,
      'pat_price': patPrice,
      'pat_jaego': patJaego,
    };
  }
}