import 'package:BliU/data/bookmark_data.dart';

class BookmarkResponseDTO {
  final bool? result;
  final int? count;  // 추가된 count 필드
  List<BookmarkData>? list;

  BookmarkResponseDTO({
    required this.result,
    required this.count,  // count 추가
    required this.list,
  });

  factory BookmarkResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<BookmarkData>.from((json['data']['list'])?.map((item) {
      return BookmarkData.fromJson(item as Map<String, dynamic>);
    }).toList());
    return BookmarkResponseDTO(
      result: json['result'],
      count: json['data']['count'],  // count 값을 추출
      list: list,
    );
  }

  // BookmarkResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'count': count,  // count 포함
        'list': list?.map((store) => store.toJson()).toList(),
      },
    };
  }
}