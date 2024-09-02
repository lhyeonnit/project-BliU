class FcmData {
  final String? title;
  final String? body;

  FcmData({
    required this.title,
    required this.body,
  });

  FcmData.fromJson(Map<String, dynamic> json):
        title = json['title'],
        body = json['body'];

  Map<String, dynamic> toJson() => {
    'title' : title,
    'body' : body,
  };
}