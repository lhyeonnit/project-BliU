import 'package:BliU/data/faq_data.dart';

class FaqResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<FaqData>? list;

  FaqResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory FaqResponseDTO.fromJson(Map<String, dynamic> json) {
    return FaqResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<FaqData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}