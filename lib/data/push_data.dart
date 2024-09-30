class PushData {
  final String? pRead;
  final int? ptIdx;
  final String? ptSubject;
  final String? ptLabel;
  final String? ptLink;
  final String? ptWdate;

  PushData({
    required this.pRead,
    required this.ptIdx,
    required this.ptSubject,
    required this.ptLabel,
    required this.ptLink,
    required this.ptWdate,
  });

  // JSON to Object
  factory PushData.fromJson(Map<String, dynamic> json) {
    return PushData(
      pRead: json['p_read'],
      ptIdx: json['pt_idx'],
      ptSubject: json['pt_subject'],
      ptLabel: json['pt_label'],
      ptLink: json['pt_link'],
      ptWdate: json['pt_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'p_read': pRead,
      'pt_idx': ptIdx,
      'pt_subject': ptSubject,
      'pt_label': ptLabel,
      'pt_link': ptLink,
      'pt_wdate': ptWdate,
    };
  }
}