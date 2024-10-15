import 'package:BliU/data/my_page_info_data.dart';

class MyPageInfoResponseDTO {
  final bool result;
  final String? message;
  final MyPageInfoData? data;



  MyPageInfoResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  factory MyPageInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return MyPageInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: MyPageInfoData.fromJson(json['data']),
    );
  }

  // BookmarkResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}