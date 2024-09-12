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
    final list = List<CategoryData>.from((json['data']['list'])?.map((item) {
      return CategoryData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return CategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: list,
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