import 'package:BliU/data/search_data.dart';

class SearchResponseDTO {
  final bool? result;
  final String? message;
  final List<SearchData>? list;

  SearchResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory SearchResponseDTO.fromJson(Map<String, dynamic> json) {
    return SearchResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<SearchData>),
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