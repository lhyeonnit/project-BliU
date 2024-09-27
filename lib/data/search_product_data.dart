class SearchProductData {
  final int? ptIdx;
  final String? ptName;

  SearchProductData({
    required this.ptIdx,
    required this.ptName,
  });

  // JSON to Object
  factory SearchProductData.fromJson(Map<String, dynamic> json) {
    return SearchProductData(
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'pt_idx': ptIdx,
      'pt_name': ptName,
    };
  }
}