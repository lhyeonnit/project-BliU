class FaqData {
  final String? ftSubject;
  final String? ftContent;

  FaqData({
    required this.ftSubject,
    required this.ftContent,
  });

  // JSON to Object
  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      ftSubject: json['ft_subject'],
      ftContent: json['ft_content'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ft_subject': ftSubject,
      'cft_name': ftContent,
    };
  }
}