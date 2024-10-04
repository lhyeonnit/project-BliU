import 'package:BliU/data/faq_data.dart';

class FindIdResponseDTO {
  final bool? result;
  final String? id;

  FindIdResponseDTO({
    required this.result,
    required this.id,

  });

  // JSON to Object
  factory FindIdResponseDTO.fromJson(Map<String, dynamic> json) {
    return FindIdResponseDTO(
      result: json['result'],
      id: json['data']['id'],

    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'id': id,
      }
    };
  }
}