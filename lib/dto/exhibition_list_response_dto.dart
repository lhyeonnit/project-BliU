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
    final list = List<ExhibitionData>.from((json['data']['list'])?.map((item) {
      return ExhibitionData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return ExhibitionListResponseDTO(
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