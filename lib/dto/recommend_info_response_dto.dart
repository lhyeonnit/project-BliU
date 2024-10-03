
class RecommendInfoResponseDTO {
  final bool result;
  final String? message;
  final Map<String, dynamic>? data;

  RecommendInfoResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  factory RecommendInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return RecommendInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: json['data'],
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
