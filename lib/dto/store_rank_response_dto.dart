import 'package:BliU/data/store_rank_data.dart';

class StoreRankResponseDTO {
  final bool result;
  List<StoreRankData>? list;

  StoreRankResponseDTO({
    required this.result,
    required this.list,
  });

  // JSON 데이터를 StoreDetailResponseDTO 객체로 변환하는 factory 메서드
  factory StoreRankResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<StoreRankData>.from((json['data']['list'])?.map((item) {
      return StoreRankData.fromJson(item as Map<String, dynamic>);
    }).toList());
    return StoreRankResponseDTO(
      result: json['result'],
      list: list,
    );
  }

  // StoreDetailResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}