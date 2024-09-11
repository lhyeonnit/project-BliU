import 'package:BliU/data/category_data.dart';

class CategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<CategoryData>? list;

  CategoryResponseDTO({
    required this.result,
    required this.message,
    this.list
  });

  // JSON to Object
  factory CategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return CategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<CategoryData>),
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