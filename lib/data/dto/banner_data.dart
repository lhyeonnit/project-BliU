class BannerDTO {
  final int? btIdx;
  final String? btImg;
  final String? btContentType;

  BannerDTO({
    required this.btIdx,
    required this.btImg,
    required this.btContentType,
  });

  // JSON to Object
  factory BannerDTO.fromJson(Map<String, dynamic> json) {
    return BannerDTO(
      btIdx: json['bt_idx'],
      btImg: json['bt_img'],
      btContentType: json['bt_content_type'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'bt_idx': btIdx,
      'bt_img': btImg,
      'bt_content_type': btContentType,
    };
  }
}

class BannerListResponseDTO {
  final bool? result;
  final String? message;
  final List<BannerDTO>? list;

  BannerListResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory BannerListResponseDTO.fromJson(Map<String, dynamic> json) {
    return BannerListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<BannerDTO>),
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

class BannerDetailResponseDTO {
  final bool? result;
  final String? message;
  final BannerDTO? data;

  BannerDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory BannerDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return BannerDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as BannerDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}