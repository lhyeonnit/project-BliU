class SearchPopularData {
  final int? sltRank;
  final String? sltTxt;

  SearchPopularData({
    required this.sltRank,
    required this.sltTxt,
  });

  // JSON to Object
  factory SearchPopularData.fromJson(Map<String, dynamic> json) {
    return SearchPopularData(
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