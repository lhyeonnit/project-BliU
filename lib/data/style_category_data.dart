class StyleCategoryDTO {
  final int? fsIdx;
  final String? cstName;


  StyleCategoryDTO({
    required this.fsIdx,
    required this.cstName,
  });

  // JSON to Object
  factory StyleCategoryDTO.fromJson(Map<String, dynamic> json) {
    return StyleCategoryDTO(
      fsIdx: json['fs_idx'],
      cstName: json['cst_name'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'fs_idx': fsIdx,
      'cst_name': cstName,
    };
  }
}

class StyleCategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<StyleCategoryDTO>? list;

  StyleCategoryResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory StyleCategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return StyleCategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<StyleCategoryDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}