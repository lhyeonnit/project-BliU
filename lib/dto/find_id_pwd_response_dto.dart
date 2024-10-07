class FindIdPwdResponseDTO {
  final bool result;
  final String? message;
  final String? id;
  final int? idx;
  final String? pwdToken;

  FindIdPwdResponseDTO({
    required this.result,
    required this.message,
    this.id,
    this.idx,
    this.pwdToken,
  });

  factory FindIdPwdResponseDTO.fromJson(Map<String, dynamic> json) {
    return FindIdPwdResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      id: json['data']['id'],
      idx: json['data']['idx'],
      pwdToken: json['data']['pwd_token'],
    );
  }

  // BookmarkResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'message': message,
        'id': id,
        'idx': idx,
        'pwd_token': pwdToken,
      },
    };
  }
}