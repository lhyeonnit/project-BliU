import 'package:BliU/data/search_my_data.dart';

class SearchMyListResponseDTO {
  final bool? result;
  final List<SearchMyData>? list;

  SearchMyListResponseDTO({
    this.result,
    this.list,
  });

  // JSON to Object
  factory SearchMyListResponseDTO.fromJson(Map<String, dynamic> json) {
    return SearchMyListResponseDTO(
      result: json['result'],
      list: (json['data']['list'] as List<dynamic>?)
          ?.map((item) => SearchMyData.fromJson(item))
          .toList(),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'list': list?.map((item) => item.toJson()).toList(),
      }
    };
  }
}
