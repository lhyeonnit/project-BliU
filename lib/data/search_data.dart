class SearchData {
  final int? sltRank;
  final String? sltTxt;

  SearchData({
    required this.sltRank,
    required this.sltTxt,
  });

  // JSON to Object
  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      sltRank: json['slt_rank'],
      sltTxt: json['slt_txt'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'slt_rank': sltRank,
      'slt_txt': sltTxt,
    };
  }
}