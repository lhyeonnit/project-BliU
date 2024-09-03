class ReviewData {
  final int? rtIdx;
  final String? reviewImg;
  final String? mtId;
  final String? rtStart;
  final String? rtContent;
  final String? rtWdate;

  ReviewData({
    required this.rtIdx,
    required this.reviewImg,
    required this.mtId,
    required this.rtStart,
    required this.rtContent,
    required this.rtWdate,
  });

  // JSON to Object
  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      rtIdx: json['rt_idx'],
      reviewImg: json['review_img'],
      mtId: json['mt_id'],
      rtStart: json['rt_start'],
      rtContent: json['rt_content'],
      rtWdate: json['rt_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'rt_idx': rtIdx,
      'review_img': reviewImg,
      'mt_id': mtId,
      'rt_start': rtStart,
      'rt_content': rtContent,
      'rt_wdate': rtWdate,
    };
  }
}

