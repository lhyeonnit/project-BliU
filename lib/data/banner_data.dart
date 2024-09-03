class BannerData {
  final int? btIdx;
  final String? btImg;
  final String? btContentType;

  BannerData({
    required this.btIdx,
    required this.btImg,
    required this.btContentType,
  });

  // JSON to Object
  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      btIdx: json['bt_idx'],
      btImg: json['bt_img'],
      btContentType: json['bt_content_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'bt_idx': btIdx,
      'bt_img': btImg,
      'bt_content_type': btContentType,
    };
  }
}