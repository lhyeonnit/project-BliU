class NoticeData {
  final int? ntIdx;
  final String? ntTitle;
  final String? ntContent;
  final String? ntWdate;

  NoticeData({
    required this.ntIdx,
    required this.ntTitle,
    required this.ntContent,
    required this.ntWdate,
  });

  // JSON to Object
  factory NoticeData.fromJson(Map<String, dynamic> json) {
    return NoticeData(
      ntIdx: json['nt_idx'],
      ntTitle: json['nt_title'],
      ntContent: json['nt_content'],
      ntWdate: json['nt_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'nt_idx': ntIdx,
      'nt_title': ntTitle,
      'nt_content': ntContent,
      'nt_wdate': ntWdate,
    };
  }
}