class FaqDTO {
  final String? ftSubject;
  final String? ftContent;

  FaqDTO({
    required this.ftSubject,
    required this.ftContent,
  });

  // JSON to Object
  factory FaqDTO.fromJson(Map<String, dynamic> json) {
    return FaqDTO(
      ftSubject: json['ft_subject'],
      ftContent: json['ft_content'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ft_subject': ftSubject,
      'cft_name': ftContent,
    };
  }
}

class FaqResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<FaqDTO>? list;

  FaqResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory FaqResponseDTO.fromJson(Map<String, dynamic> json) {
    return FaqResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<FaqDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}