class FcmData {
  final String? title;
  final String? body;
  final String? ptLink;
  final String? etIdx;

  FcmData({
    required this.title,
    required this.body,
    required this.ptLink,
    required this.etIdx,
  });

  FcmData.fromJson(Map<String, dynamic> json):
        title = json['title'],
        body = json['body'],
        ptLink = json['pt_link'],
        etIdx = json['et_idx'];

  Map<String, dynamic> toJson() => {
    'title' : title,
    'body' : body,
    'pt_link' : ptLink,
    'et_idx' : etIdx,
  };
}