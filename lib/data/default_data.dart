class DefaultData {
  final bool result;
  final String? message;

  DefaultData({
    required this.result,
    required this.message,
  });

  factory DefaultData.fromJson(Map<String, dynamic> json) {
    return DefaultData(
      result: json['result'],
      message: json['data']['message'],
    );
  }

  // BookmarkResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'message': message
      },
    };
  }
}

