class SearchStoreData {
  final int? stIdx;
  final String? stName;
  final String? stProfile;

  SearchStoreData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
  });

  // JSON to Object
  factory SearchStoreData.fromJson(Map<String, dynamic> json) {
    return SearchStoreData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
    };
  }
}