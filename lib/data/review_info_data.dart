class ReviewInfoData {
  final int? starAvg;
  final int? reviewCount;

  ReviewInfoData({
    required this.starAvg,
    required this.reviewCount,
  });

  // JSON to Object
  factory ReviewInfoData.fromJson(Map<String, dynamic> json) {
    return ReviewInfoData(
      starAvg: json['star_avg'],
      reviewCount: json['review_count'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'star_avg': starAvg,
      'review_count': reviewCount,
    };
  }
}