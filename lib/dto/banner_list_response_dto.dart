import 'package:BliU/data/banner_data.dart';

class BannerListResponseDTO {
  final bool? result;
  final String? message;
  final List<BannerData>? list;

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
      list: (json['data']['list'] as List<BannerData>),
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