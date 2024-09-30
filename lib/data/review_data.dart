class ReviewData {
  final String? myReview;
  final int? rtIdx;
  final String? mtId;
  final String? rtStart;
  final String? rtContent;
  final String? rtWdate;
  final List<String>? imgArr;
  final String? rtImg;
  final String? stName;
  final String? ptName;
  final String? ctOptName;
  final String? ctOptValue;

  ReviewData({
    required this.myReview,
    required this.rtIdx,
    required this.mtId,
    required this.rtStart,
    required this.rtContent,
    required this.rtWdate,
    required this.imgArr,
    required this.rtImg,
    required this.stName,
    required this.ptName,
    required this.ctOptName,
    required this.ctOptValue,
  });

  // JSON to Object
  factory ReviewData.fromJson(Map<String, dynamic> json) {
    List<String>? imgArr;
    if (json['img_arr'] != null) {
      imgArr = List<String>.from(json['img_arr']);
    }
    return ReviewData(
      myReview: json['my_review'],
      rtIdx: json['rt_idx'],
      mtId: json['mt_id'],
      rtStart: json['rt_start'],
      rtContent: json['rt_content'],
      rtWdate: json['rt_wdate'],
      imgArr: imgArr,
      rtImg: json['rt_img'],
      stName: json['st_name'],
      ptName: json['pt_name'],
      ctOptName: json['ct_opt_name'],
      ctOptValue: json['ct_opt_value'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'my_review': myReview,
      'rt_idx': rtIdx,
      'mt_id': mtId,
      'rt_start': rtStart,
      'rt_content': rtContent,
      'rt_wdate': rtWdate,
      'img_arr': imgArr,
      'rt_img': rtImg,
      'st_name': stName,
      'pt_name': ptName,
      'ct_opt_name': ctOptName,
      'ct_opt_value': ctOptValue,
    };
  }
}

