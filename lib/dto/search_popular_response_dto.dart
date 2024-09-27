
import 'package:BliU/data/search_popular_data.dart';


class SearchPopularResponseDTO {
  final bool? result;
  final List<SearchPopularData>? list;

  SearchPopularResponseDTO({
    required this.result,
    required this.list,
  });

  // JSON to Object
  factory SearchPopularResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<SearchPopularData>.from((json['data']['list'])?.map((item) {
      return SearchPopularData.fromJson(item as Map<String, dynamic>);
    }).toList());
    return SearchPopularResponseDTO(
      result: json['result'],
      list: list,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}