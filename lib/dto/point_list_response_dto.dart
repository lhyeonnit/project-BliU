import 'package:BliU/data/point_data.dart';

class PointListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final int? mtPoint;
  final List<PointData>? list;

  PointListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.mtPoint,
    required this.list
  });

  // JSON to Object
  factory PointListResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<PointData>.from((json['data']['list'])?.map((item) {
      return PointData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return PointListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      mtPoint: json['data']['mt_point'],
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
        'mt_point': mtPoint,
        'list': list?.map((it) => it.toJson()).toList(),
      },
    };
  }
}