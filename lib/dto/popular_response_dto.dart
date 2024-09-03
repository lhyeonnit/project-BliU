import 'package:BliU/data/popular_data.dart';

class PopularResponseDTO {
  final bool? result;
  final String? message;
  final List<PopularData>? list;

  PopularResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory PopularResponseDTO.fromJson(Map<String, dynamic> json) {
    return PopularResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<PopularData>),
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