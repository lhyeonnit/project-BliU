class ReviewInfoData {
  final String? startAvg;
  final int? reviewCount;

  ReviewInfoData({
    required this.startAvg,
    required this.reviewCount,
  });

  // JSON to Object
  factory ReviewInfoData.fromJson(Map<String, dynamic> json) {
    return ReviewInfoData(
      startAvg: json['start_avg'],
      reviewCount: json['review_count'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'star_avg': startAvg,
      'review_count': reviewCount,
    };
  }
}