class PushDTO {
  final String? pRead;
  final int? ptIdx;
  final String? ptSubject;
  final String? ptLabel;
  final String? ptLink;

  PushDTO({
    required this.pRead,
    required this.ptIdx,
    required this.ptSubject,
    required this.ptLabel,
    required this.ptLink,
  });

  // JSON to Object
  factory PushDTO.fromJson(Map<String, dynamic> json) {
    return PushDTO(
      pRead: json['p_read'],
      ptIdx: json['pt_idx'],
      ptSubject: json['pt_subject'],
      ptLabel: json['pt_label'],
      ptLink: json['pt_link'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'p_read': pRead,
      'pt_idx': ptIdx,
      'pt_subject': ptSubject,
      'pt_label': ptLabel,
      'pt_link': ptLink,
    };
  }
}

class PushResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<PushDTO>? list;

  PushResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list,
  });

  // JSON to Object
  factory PushResponseDTO.fromJson(Map<String, dynamic> json) {
    return PushResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<PushDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : {
        'count': list?.length,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}