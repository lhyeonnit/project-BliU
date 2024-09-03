class FaqCategoryData {
  final int? fcIdx;
  final String? cftName;

  FaqCategoryData({
    required this.fcIdx,
    required this.cftName,
  });

  // JSON to Object
  factory FaqCategoryData.fromJson(Map<String, dynamic> json) {
    return FaqCategoryData(
      fcIdx: json['fc_idx'],
      cftName: json['cft_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'fc_idx': fcIdx,
      'cft_name': cftName,
    };
  }
}