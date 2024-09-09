import 'package:BliU/data/faq_data.dart';

class FaqResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  List<FaqData>? list;

  FaqResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    this.list
  });

  // JSON to Object
  factory FaqResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<FaqData>.from((json['data']['list'])?.map((item) {
      return FaqData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return FaqResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: list,
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