class PopularData {
  final int? sltRank;
  final String? sltTxt;

  PopularData({
    required this.sltRank,
    required this.sltTxt,
  });

  // JSON to Object
  factory PopularData.fromJson(Map<String, dynamic> json) {
    return PopularData(
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