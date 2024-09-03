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
    return FaqCategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<FaqCategoryData>),
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