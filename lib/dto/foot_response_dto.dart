import 'package:BliU/data/foot_data.dart';

class FootResponseDTO {
  final bool? result;
  final String? message;
  final FootData? data;

  FootResponseDTO({
    required this.result,
    required this.message,
    this.data
  });

  // JSON to Object
  factory FootResponseDTO.fromJson(Map<String, dynamic> json) {
    return FootResponseDTO(
      result: json['result'],
      message: (json['data'] is List ? null : json['data']['message']),
      data: FootData.fromJson(json['data'][0]),
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