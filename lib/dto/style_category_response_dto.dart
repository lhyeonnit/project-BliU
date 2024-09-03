import 'package:BliU/data/style_category_data.dart';

class StyleCategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<StyleCategoryData>? list;

  StyleCategoryResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory StyleCategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return StyleCategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<StyleCategoryData>),
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