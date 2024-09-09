import 'package:BliU/data/event_data.dart';

class EventListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  List<EventData>? list;

  EventListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory EventListResponseDTO.fromJson(Map<String, dynamic> json) {
    final list = List<EventData>.from((json['data']['list'])?.map((item) {
      return EventData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return EventListResponseDTO(
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