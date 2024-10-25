class MyPageInfoData{
  final String? mtId;
  final int? mtIdx;
  final int? mtLoginType;
  String? mtHp;
  String? mtName;
  String? mtBirth;
  String? mtGender;
  final String? authToken;

  MyPageInfoData({
    required this.mtId,
    required this.mtIdx,
    required this.mtLoginType,
    required this.mtHp,
    required this.mtName,
    required this.mtBirth,
    required this.mtGender,
    this.authToken,
  });

  factory MyPageInfoData.fromJson(Map<String, dynamic> json) {
    return MyPageInfoData(
      mtId: json['mt_id'],
      mtIdx: json['mt_idx'],
      mtLoginType: json['mt_login_type'],
      mtHp: json['mt_hp'],
      mtName: json['mt_name'],
      mtBirth: json['mt_birth'],
      mtGender: json['mt_gender'],
      authToken: json['auth_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mt_id': mtId,
      'mt_idx': mtIdx,
      'mt_login_type': mtLoginType,
      'mt_hp': mtHp,
      'mt_name': mtName,
      'mt_birth': mtBirth,
      'mt_gender': mtGender,
      'auth_token': authToken,
    };
  }
}