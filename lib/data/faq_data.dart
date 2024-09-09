class FaqData {
  final int? cftIdx;
  final String? ftSubject;
  final String? ftContent;

  FaqData({
    required this.cftIdx,
    required this.ftSubject,
    required this.ftContent,
  });

  // JSON to Object
  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      cftIdx: json['cft_idx'],
      ftSubject: json['ft_subject'],
      ftContent: json['ft_content'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'cft_idx': cftIdx,
      'ft_subject': ftSubject,
      'cft_name': ftContent,
    };
  }
}