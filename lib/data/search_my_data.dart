class SearchMyData {
  final int? sltIdx;
  final String? sltTxt;

  SearchMyData({
    required this.sltIdx,
    required this.sltTxt,
  });

  // JSON to Object
  factory SearchMyData.fromJson(Map<String, dynamic> json) {
    return SearchMyData(
      sltIdx: json['slt_idx'],
      sltTxt: json['slt_txt'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'slt_idx': sltIdx,
      'slt_txt': sltTxt,
    };
  }
}