class NoticeDTO {
  final int? ntIdx;
  final String? ntTitle;
  final String? ntContent;
  final String? ntWdate;

  NoticeDTO({
    required this.ntIdx,
    required this.ntTitle,
    required this.ntContent,
    required this.ntWdate,
  });

  // JSON to Object
  factory NoticeDTO.fromJson(Map<String, dynamic> json) {
    return NoticeDTO(
      ntIdx: json['nt_idx'],
      ntTitle: json['nt_title'],
      ntContent: json['nt_content'],
      ntWdate: json['nt_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'nt_idx': ntIdx,
      'nt_title': ntTitle,
      'nt_content': ntContent,
      'nt_wdate': ntWdate,
    };
  }
}

class NoticeListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<NoticeDTO>? list;

  NoticeListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory NoticeListResponseDTO.fromJson(Map<String, dynamic> json) {
    return NoticeListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<NoticeDTO>),
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

class NoticeDetailResponseDTO {
  final bool? result;
  final String? message;
  final NoticeDTO? data;

  NoticeDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory NoticeDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return NoticeDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as NoticeDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson()
    };
  }
}