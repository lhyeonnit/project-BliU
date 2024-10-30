class CancelDetailInfoData {
  final String? octWdate;
  final int? octCancel;
  final String? octCancelTxt;
  final String? octCancelMemo1;

  CancelDetailInfoData({
    required this.octWdate,
    required this.octCancel,
    required this.octCancelTxt,
    required this.octCancelMemo1,
  });

  // JSON to Object
  factory CancelDetailInfoData.fromJson(Map<String, dynamic> json) {
    return CancelDetailInfoData(
      octWdate: json['oct_wdate'],
      octCancel: json['oct_cancel'],
      octCancelTxt: json['oct_cancel_txt'],
      octCancelMemo1: json['oct_cancel_memo1'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'oct_wdate': octWdate,
      'oct_cancel': octCancel,
      'oct_cancel_txt': octCancelTxt,
      'oct_cancel_memo1': octCancelMemo1,
    };
  }
}