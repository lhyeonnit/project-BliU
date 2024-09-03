import 'package:BliU/data/exhibition_data.dart';

class ExhibitionListResponseDTO {
  final bool? result;
  final String? message;
  final List<ExhibitionData>? list;

  ExhibitionListResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory ExhibitionListResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExhibitionListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<ExhibitionData>),
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