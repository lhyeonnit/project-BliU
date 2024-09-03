class StyleCategoryData {
  final int? fsIdx;
  final String? cstName;

  StyleCategoryData({
    required this.fsIdx,
    required this.cstName,
  });

  // JSON to Object
  factory StyleCategoryData.fromJson(Map<String, dynamic> json) {
    return StyleCategoryData(
      fsIdx: json['fs_idx'],
      cstName: json['cst_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'fs_idx': fsIdx,
      'cst_name': cstName,
    };
  }
}