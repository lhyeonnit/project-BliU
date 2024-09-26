class ReviewData {
  final int? rtIdx;
  final String? mtId;
  final String? rtStart;
  final String? rtContent;
  final String? rtWdate;
  final List<String>? imgArr;

  ReviewData({
    required this.rtIdx,
    required this.mtId,
    required this.rtStart,
    required this.rtContent,
    required this.rtWdate,
    required this.imgArr,
  });

  // JSON to Object
  factory ReviewData.fromJson(Map<String, dynamic> json) {
    List<String>? imgArr;
    if (json['img_arr'] != null) {
      imgArr = List<String>.from(json['img_arr']);
    }
    return ReviewData(
      rtIdx: json['rt_idx'],
      mtId: json['mt_id'],
      rtStart: json['rt_start'],
      rtContent: json['rt_content'],
      rtWdate: json['rt_wdate'],
      imgArr: imgArr,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'rt_idx': rtIdx,
      'mt_id': mtId,
      'rt_start': rtStart,
      'rt_content': rtContent,
      'rt_wdate': rtWdate,
      'img_arr': imgArr,
    };
  }
}

