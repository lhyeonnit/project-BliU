import 'package:BliU/data/faq_category_data.dart';

class FaqCategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<FaqCategoryData>? list;

  FaqCategoryResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory FaqCategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<FaqCategoryData>.from((json['data']['list'])?.map((item) {
      return FaqCategoryData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return FaqCategoryResponseDTO(
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
      'list': list?.map((it) => it.toJson()).toList(),
    };
  }
}