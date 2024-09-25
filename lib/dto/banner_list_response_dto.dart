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
    final list = List<BannerData>.from((json['data']['list'])?.map((item) {
      return BannerData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return BannerListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: list,
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