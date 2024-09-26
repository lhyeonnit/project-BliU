import 'package:BliU/data/exhibition_data.dart';

class ExhibitionDetailResponseDTO {
  final bool? result;
  final String? message;
  final ExhibitionData? data;

  ExhibitionDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory ExhibitionDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExhibitionDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: ExhibitionData.fromJson(json['data']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}