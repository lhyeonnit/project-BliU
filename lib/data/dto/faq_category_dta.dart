class FaqCategoryDTO {
  final int? fcIdx;
  final String? cftName;

  FaqCategoryDTO({
    required this.fcIdx,
    required this.cftName,
  });

  // JSON to Object
  factory FaqCategoryDTO.fromJson(Map<String, dynamic> json) {
    return FaqCategoryDTO(
      fcIdx: json['fc_idx'],
      cftName: json['cft_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'fc_idx': fcIdx,
      'cft_name': cftName,
    };
  }
}

class FaqCategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<FaqCategoryDTO>? list;

  FaqCategoryResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory FaqCategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return FaqCategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<FaqCategoryDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'list': list?.map((it) => it.toJson()).toList(),
    };
  }
}