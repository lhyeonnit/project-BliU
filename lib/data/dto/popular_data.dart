class PopularDTO {
  final int? sltRank;
  final String? sltTxt;

  PopularDTO({
    required this.sltRank,
    required this.sltTxt,
  });

  // JSON to Object
  factory PopularDTO.fromJson(Map<String, dynamic> json) {
    return PopularDTO(
      sltRank: json['slt_rank'],
      sltTxt: json['slt_txt'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'slt_rank': sltRank,
      'slt_txt': sltTxt,
    };
  }
}

class PopularResponseDTO {
  final bool? result;
  final String? message;
  final List<PopularDTO>? list;

  PopularResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory PopularResponseDTO.fromJson(Map<String, dynamic> json) {
    return PopularResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<PopularDTO>),
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