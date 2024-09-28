import 'package:BliU/data/store_data.dart';

class StoreResponseDTO {
  final bool result;
  StoreData data;

  StoreResponseDTO({
    required this.result,
    required this.data,
  });

  // JSON 데이터를 StoreDetailResponseDTO 객체로 변환하는 factory 메서드
  factory StoreResponseDTO.fromJson(Map<String, dynamic> json) {
    return StoreResponseDTO(
      result: json['result'],
      data: StoreData.fromJson(json['data']),
    );
  }

  // StoreDetailResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.toJson(),
    };
  }
}