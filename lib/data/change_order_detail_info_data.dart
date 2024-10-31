class ChangeOrderDetailInfoData {
  final String? octWdate;
  final int? octCancel;
  final String? octCancelTxt;
  final String? octCancelMemo1;
  final String? ortWdate;
  final int? ortReturn;
  final String? ortReturnTxt;
  final String? ortReturnMemo1;
  final String? ortImg;
  final String? ortReturnBankInfo;

  ChangeOrderDetailInfoData({
    required this.octWdate,
    required this.octCancel,
    required this.octCancelTxt,
    required this.octCancelMemo1,
    required this.ortWdate,
    required this.ortReturn,
    required this.ortReturnTxt,
    required this.ortReturnMemo1,
    required this.ortImg,
    required this.ortReturnBankInfo,
  });

  // JSON to Object
  factory ChangeOrderDetailInfoData.fromJson(Map<String, dynamic> json) {
    return ChangeOrderDetailInfoData(
      octWdate: json['oct_wdate'],
      octCancel: json['oct_cancel'],
      octCancelTxt: json['oct_cancel_txt'],
      octCancelMemo1: json['oct_cancel_memo1'],
      ortWdate: json['ort_wdate'],
      ortReturn: json['ort_return'],
      ortReturnTxt: json['ort_return_txt'],
      ortReturnMemo1: json['ort_return_meno1'],
      ortImg: json['ort_img'],
      ortReturnBankInfo: json['ort_return_bank_info'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'oct_wdate': octWdate,
      'oct_cancel': octCancel,
      'oct_cancel_txt': octCancelTxt,
      'oct_cancel_memo1': octCancelMemo1,
      'ort_wdate': ortWdate,
      'ort_return': ortReturn,
      'ort_return_txt': ortReturnTxt,
      'ort_return_meno1': ortReturnMemo1,
      'ort_img': ortImg,
      'ort_return_bank_info': ortReturnBankInfo,
    };
  }
}