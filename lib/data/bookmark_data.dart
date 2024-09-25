class BookmarkData {
  final int? stIdx;
  final String? stName;
  final String? stProfile;
  final String? ageTxt;
  final String? styleTxt;
  late final int? stLike;

  BookmarkData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stLike,
    required this.ageTxt,
    required this.styleTxt,
  });

  // JSON 데이터를 BookmarkStoreDTO 객체로 변환하는 factory 메서드
  factory BookmarkData.fromJson(Map<String, dynamic> json) {
    return BookmarkData(
      stIdx: json['st_idx'],  // int로 안전하게 변환
      stName: json['st_name'],
      stProfile: json['st_profile'],
      ageTxt: json['age_txt'],
      styleTxt: json['style_txt'],
      stLike: json['st_like'],  // int로 안전하게 변환
    );
  }

  // BookmarkStoreDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_like': stLike,
      'age_txt': ageTxt,
      'style_txt': styleTxt,
    };
  }
}
