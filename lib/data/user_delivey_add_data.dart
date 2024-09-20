class UserDeliveyAddData {
  final int? idx;
  final int? mtIdx;
  final String? matDefault;
  final String? matName;
  final String? matHp;
  final String? matZip;
  final String? matAdd1;
  final String? matAdd2;
  final String? matMemo1;
  final String? matWdate;

  UserDeliveyAddData({
    required this.idx,
    required this.mtIdx,
    required this.matDefault,
    required this.matName,
    required this.matHp,
    required this.matZip,
    required this.matAdd1,
    required this.matAdd2,
    required this.matMemo1,
    required this.matWdate,
  });

  // JSON to Object
  factory UserDeliveyAddData.fromJson(Map<String, dynamic> json) {
    return UserDeliveyAddData(
      idx: json['idx'],
      mtIdx: json['mt_idx'],
      matDefault: json['mat_default'],
      matName: json['mat_name'],
      matHp: json['mat_hp'],
      matZip: json['mat_zip'],
      matAdd1: json['mat_add1'],
      matAdd2: json['mat_add2'],
      matMemo1: json['mat_memo1'],
      matWdate: json['mat_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'mt_idx': mtIdx,
      'mat_default': matDefault,
      'mat_name': matName,
      'mat_hp': matHp,
      'mat_zip': matZip,
      'mat_add1': matAdd1,
      'mat_add2': matAdd2,
      'mat_memo1': matMemo1,
      'mat_wdate': matWdate,
    };
  }
}