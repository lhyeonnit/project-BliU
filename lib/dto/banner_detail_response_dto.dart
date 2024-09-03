import 'package:BliU/data/banner_data.dart';

class BannerDetailResponseDTO {
  final bool? result;
  final String? message;
  final BannerData? data;

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
      data: (json['data'] as BannerData),
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